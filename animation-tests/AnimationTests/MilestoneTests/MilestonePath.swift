import SwiftUI

struct MilestonePath: Shape {
	enum RelevantPoints {
		case firstTurn
		case lastTurn
		case arc(Int)
		case startOfSegment(Int)
		case segment(Int, dividedIn: Int, positionedAt: Int)
	}

	/// Number of arcs, excluding bottom and top small arcs
	let numberOfArcs: Int
	/// Must equal rect's from path(in rect: CGRect) otherwise calculations won't match
	let size: CGSize

	private let initialPoint: CGPoint

	init(numberOfArcs: Int, rect: CGRect) {
		self.numberOfArcs = numberOfArcs
		self.size = .init(width: rect.width, height: rect.height)
		print("init size \(size)")
		//print("init RECT MidX \(adjustedRect.midX)")
		self.initialPoint = CGPoint(x: rect.midX, y: rect.maxY)
		print("init initialPoint \(initialPoint)")
	}

	func path(in rect: CGRect) -> Path {
		let lineWidth = rect.width - (2 * .largeRadius)
		let initialLineWidth = (rect.width / 2) - (.largeRadius + .smallRadius)

		var path = Path()

		// TODO: Should we consider the else scenario?
		guard numberOfArcs >= 1 else { return path }

		// Each iteration draws the difference from last to its arc's index (starting from 2)
		for index in  0...numberOfArcs {
			switch index {
			case 0: // Draws initial and second arc (since they are "special")
				path.move(to: rect.startingPoint)
				path.addLineUp(length: .bottomAndTopmostLinesUp)
				path.addBottommostArc()
				path.addRightToLeftLine(length: initialLineWidth)
				path.addLeftArc()

			case numberOfArcs: // Last arc. Previous arc can be on the left or right side
				if index.isEven {
					path.addRightToLeftLine(length: initialLineWidth)
					path.addTopmostArcFromRight()
					path.addLineUp(length: .bottomAndTopmostLinesUp)
				} else {
					path.addLeftToRightLine(length: initialLineWidth)
					path.addTopmostArcFromLeft()
					path.addLineUp(length: .bottomAndTopmostLinesUp)
				}

			default:
				if index.isEven { // Arc is on the left side
					path.addRightToLeftLine(length: lineWidth)
					path.addLeftArc()
				} else { // Arc is on the right side
					path.addLeftToRightLine(length: lineWidth)
					path.addRightArc()
				}
			}
		}

		return path
	}

	var fixedInitialAndFinalLength: CGFloat {
		let smallArcLength = arcLength(radius: .smallRadius, partialAngle: .degrees(.straightAngle))
		let initialHorizontalLineWidth = (size.width / 2) - (.largeRadius + .smallRadius)
		return .bottomAndTopmostLinesUp + smallArcLength + initialHorizontalLineWidth
	}

	var lineSegmentWidth: CGFloat { size.width - (2 * .largeRadius) }

	var totalHeight: CGFloat {
		let path = self.path(in: .init(size: size))
		let initial = path.pointAt(length: 0, fallback: initialPoint)
		let final = path.pointAt(length: 1, fallback: initialPoint)
		return abs(final.y - initial.y)
	}

	var innerHeight: CGFloat { max(0, totalHeight - (2 * fixedInitialAndFinalLength))}

	var bottommostPoint: CGPoint {
		let path = self.path(in: .init(size: size))
		let point = path.pointAt(length: 0, fallback: initialPoint)
		return adjustPointIfNeeded(point, in: path)
	}

	var topmostPoint: CGPoint {
		let path = self.path(in: .init(size: size))
		let point = path.pointAt(length: 1, fallback: initialPoint)
		return adjustPointIfNeeded(point, in: path)
	}

	func pointAt(_ placement: RelevantPoints) -> CGPoint {
		switch placement {
		case .firstTurn:
			pointBeforeFirstArc()
		case .lastTurn:
			pointAfterLastArc()
		case let .arc(index):
			pointAtArc(index)
		case let .startOfSegment(index):
			pointsAtSegment(index, dividedIn: 1)[safeIndex: 0] ?? initialPoint
		case let .segment(index, parts, positionedAt):
			pointsAtSegment(index, dividedIn: parts)[safeIndex: positionedAt] ?? initialPoint
		}
	}

	func partialPathUpTo(_ placement: RelevantPoints) -> Path {
		switch placement {
		case .firstTurn: pathBeforeFirstArc()
		case .lastTurn: pathAfterLastArc()
		case let .arc(index): pathToArc(index)
		case let .startOfSegment(index): pathToSegment(index, dividedIn: 1, position: 0)
		case let .segment(index, parts, positionedAt): pathToSegment(index, dividedIn: parts, position: positionedAt)
		}
	}

	/// Returns the point of the path located in the "middle" if the arc. Zero based index.
	private func pointAtArc(_ index: Int) -> CGPoint {
		let path = self.path(in: .init(size: size))
		let point = path.pointAt(length: relativeLengthOfArc(index), fallback: initialPoint)
		return adjustPointIfNeeded(point, in: path)
	}

	func pointsAtSegment(_ index: Int, dividedIn numberSegments: Int) -> [CGPoint] {
		let path = self.path(in: .init(size: size))
		let lengths = relativeLengthsOfPointsAtSegment(index, numberSegments: numberSegments)
		return lengths.map { length in
			adjustPointIfNeeded(path.pointAt(length: length, fallback: initialPoint), in: path)
		}
	}

	private func pathToSegment(_ index: Int, dividedIn numberSegments: Int, position: Int) -> Path {
		let path = self.path(in: .init(size: size))
		let lengths = relativeLengthsOfPointsAtSegment(index, numberSegments: numberSegments)
		guard let length = lengths[safeIndex: position] else { return path }
		return path.pathWith(relativeLength: length)
	}

	//////
	private func pointBeforeFirstArc() -> CGPoint {
		let path = self.path(in: .init(size: size))
		let point = path.pointAt(length: fixedInitialAndFinalLength / totalLength, fallback: initialPoint)
		return adjustPointIfNeeded(point, in: path)
	}

	private func pointAfterLastArc() -> CGPoint {
		let path = self.path(in: .init(size: size))
		let relativeLength = (totalLength - fixedInitialAndFinalLength) / totalLength
		let point = path.pointAt(length: relativeLength, fallback: initialPoint)
		return adjustPointIfNeeded(point, in: path)
	}

	private func pathBeforeFirstArc() -> Path {
		let path = self.path(in: .init(size: size))
		return path.pathWith(relativeLength: fixedInitialAndFinalLength / totalLength)
	}

	private func pathAfterLastArc() -> Path {
		let relativeLength = (totalLength - fixedInitialAndFinalLength) / totalLength
		return self.path(in: .init(size: size)).pathWith(relativeLength: relativeLength)
	}

	private func pathToArc(_ index: Int) -> Path {
		let path = self.path(in: .init(size: size))
		return path.trimmedPath(from: 0, to: relativeLengthOfArc(index))
	}

	/////

	private func relativeLengthOfArc(_ index: Int) -> CGFloat {
		let largeArcsLength = CGFloat(index) * arcLength(radius: .largeRadius, partialAngle: .degrees(.halfTurn))
		let segmentsLength = CGFloat(index) * lineSegmentWidth

		// Position at "middle" of the arc
		let ninetyDegreesForward = arcLength(radius: .largeRadius, partialAngle: .degrees(.straightAngle))

		let absoluteLength = fixedInitialAndFinalLength
		+ largeArcsLength
		+ segmentsLength
		+ ninetyDegreesForward

		return absoluteLength / totalLength
	}

	private func relativeLengthsOfPointsAtSegment(_ segmentIndex: Int, numberSegments: Int)  -> [CGFloat] {
		let largeArcsLength = CGFloat(segmentIndex + 1) * arcLength(radius: .largeRadius, partialAngle: .degrees(.halfTurn))
		let segmentsLength = CGFloat(segmentIndex) * lineSegmentWidth

		let lengthToSegmentStart = fixedInitialAndFinalLength
		+ largeArcsLength
		+ segmentsLength
		let lengthToSegmentEnd = lengthToSegmentStart + lineSegmentWidth

		let distanceBetweenEachPoint = (lengthToSegmentEnd - lengthToSegmentStart) / CGFloat(max(1, numberSegments))

		let pointsRelativePositions = (0...numberSegments).map {
			let displacementOfPoint = distanceBetweenEachPoint * CGFloat($0)
			return (lengthToSegmentStart + displacementOfPoint) / totalLength
		}

		return pointsRelativePositions
	}

	private var totalLength: CGFloat {
		let largeArcsLength = CGFloat(numberOfArcs) * arcLength(radius: .largeRadius, partialAngle: .degrees(.halfTurn))
		let segmentsLength = CGFloat(numberOfArcs - 1) * lineSegmentWidth
		return (fixedInitialAndFinalLength * 2) + largeArcsLength + segmentsLength
	}

	private func arcLength(radius: CGFloat, partialAngle: Angle = .radians(2 * .pi)) -> CGFloat {
		let limitedToOneTurnAngle = min(2 * .pi, partialAngle.radians.magnitude)
		return limitedToOneTurnAngle * radius
	}

	/// If the path goes beyond screen size, trimmedPath doesn't work properly
	/// We need to compensate by adding the the part (negative) that stays off screen
	private func adjustPointIfNeeded(_ originalPoint: CGPoint, in path: Path) -> CGPoint {
		let topmostYInPath = path.pointAt(length: 1, fallback: initialPoint).y
		let adjustedPoint = CGPoint(x: originalPoint.x, y: originalPoint.y + abs(topmostYInPath))
		return topmostYInPath < 0 ? adjustedPoint : originalPoint
	}
}

private extension Path {
	var currentX: CGFloat { self.currentPoint?.x ?? .zero }
	var currentY: CGFloat { self.currentPoint?.y ?? .zero }

	/// Returns the point after trimming the path to the relative length
	func pointAt(length: CGFloat, fallback: CGPoint) -> CGPoint {
		self.trimmedPath(from: 0, to: length).currentPoint ?? fallback
	}

	/// Returns a partial after trimming the original path to the relative length
	func pathWith(relativeLength: CGFloat) -> Path {
		self.trimmedPath(from: 0, to: relativeLength)
	}

	mutating func addBottommostArc() {
		addRelativeArc(
			center: .init(x:  currentX - .smallRadius, y: currentY),
			radius: .smallRadius,
			startAngle: .degrees(.zero),
			delta: .degrees(-.straightAngle)
		)
	}

	mutating func addTopmostArcFromRight() {
		addRelativeArc(
			center: .init(x:  currentX, y: currentY - .smallRadius),
			radius: .smallRadius,
			startAngle: .degrees(.straightAngle),
			delta: .degrees(.straightAngle)
		)
	}

	mutating func addTopmostArcFromLeft() {
		addRelativeArc(
			center: .init(x:  currentX, y: currentY - .smallRadius),
			radius: .smallRadius,
			startAngle: .degrees(.straightAngle),
			delta: .degrees(-.straightAngle)
		)
	}

	mutating func addLeftArc() {
		addRelativeArc(
			center: .init(x:  currentX, y: currentY - .largeRadius),
			radius: .largeRadius,
			startAngle: .degrees(.straightAngle), // Always 90
			delta: .degrees(.halfTurn) // Positive angle: arc is on the left side
		)
	}

	mutating func addRightArc() {
		addRelativeArc(
			center: .init(x: currentX, y: currentY - .largeRadius),
			radius: .largeRadius,
			startAngle: .degrees(.straightAngle),
			delta: .degrees(-.halfTurn) // Negative angle: arc is on the right side
		)
	}

	mutating func addLeftToRightLine(length: CGFloat) {
		addLine(to: CGPoint(x: currentX + length, y: currentY))
	}

	mutating func addRightToLeftLine(length: CGFloat) {
		addLine(to: CGPoint(x: currentX - length, y: currentY))
	}

	mutating func addLineUp(length: CGFloat) {
		addLine(to: CGPoint(x: currentX, y: currentY - length))
	}
}

private extension Double {
	static let straightAngle: Self = 90
	static let halfTurn: Self = 180
}

private extension CGFloat {
	static let bottomAndTopmostLinesUp: Self = 50
	static let smallRadius: Self = 30
	static let largeRadius: Self = 60
}

extension Int {
	var isEven: Bool { self % 2 == 0 }
}

private extension CGRect {
	var startingPoint: CGPoint { .init(x: self.midX, y: self.maxY) }

	init(size: CGSize) { self.init(origin: .zero, size: size) }
}
