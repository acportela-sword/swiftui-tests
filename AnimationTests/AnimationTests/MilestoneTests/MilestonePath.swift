import SwiftUI

struct MilestonePath: Shape {
	/// Number of arcs, excluding bottom and top small arcs
	let numberOfArcs: Int
	/// Must equal rect's from path(in rect: CGRect) otherwise calculations won't match
	let size: CGSize

	private let initialPoint: CGPoint

	init(numberOfArcs: Int, rect: CGRect) {
		self.numberOfArcs = numberOfArcs
		self.size = rect.size
		self.initialPoint = CGPoint(x: rect.midX, y: rect.maxY)
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

	var totalHeight: CGFloat {
		let path = self.path(in: .init(size: size))
		let initial = path.pointAt(length: 0, fallback: initialPoint)
		let final = path.pointAt(length: 1, fallback: initialPoint)
		return abs(final.y - initial.y)
	}

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

	/// Returns the point of the path located in the "middle" if the arc. Zero based index.
	func pointAtArc(_ index: Int) -> CGPoint {
		let path = self.path(in: .init(size: size))
		let point = path.pointAt(length: relativeLengthOfArc(index), fallback: initialPoint)
		return adjustPointIfNeeded(point, in: path)
	}

	func pointsAtSegment(_ index: Int, numberOfPoints: Int) -> [CGPoint] {
		let path = self.path(in: .init(size: size))
		let lengths = relativeLengthsOfPointsAtSegment(index, numberOfPoints: numberOfPoints)
		return lengths.map { length in
			adjustPointIfNeeded(path.pointAt(length: length, fallback: initialPoint), in: path)
		}
	}

	private func relativeLengthOfArc(_ index: Int) -> CGFloat {
		let lineWidth = size.width - (2 * .largeRadius)

		let largeArcsLength = CGFloat(index) * arcLength(radius: .largeRadius, partialAngle: .degrees(.halfTurn))
		let segmentsLength = CGFloat(index) * lineWidth

		// Position at "middle" of the arc
		let ninetyDegreesForward = arcLength(radius: .largeRadius, partialAngle: .degrees(.straightAngle))

		let absoluteLength = fixedInitialAndFinalLength
		+ largeArcsLength
		+ segmentsLength
		+ ninetyDegreesForward

		return absoluteLength / totalLength
	}

	private func relativeLengthsOfPointsAtSegment(_ segmentIndex: Int, numberOfPoints: Int)  -> [CGFloat] {
		let lineWidth = size.width - (2 * .largeRadius)

		let largeArcsLength = CGFloat(segmentIndex + 1) * arcLength(radius: .largeRadius, partialAngle: .degrees(.halfTurn))
		let segmentsLength = CGFloat(segmentIndex) * lineWidth

		let lengthToSegmentStart = fixedInitialAndFinalLength
		+ largeArcsLength
		+ segmentsLength
		let lengthToSegmentEnd = lengthToSegmentStart + lineWidth

		let distanceBetweenEachPoint = (lengthToSegmentEnd - lengthToSegmentStart) / CGFloat(numberOfPoints + 1)

		let pointsRelativePositions = (1...numberOfPoints).map {
			let displacementOfPoint = distanceBetweenEachPoint * CGFloat($0)
			return (lengthToSegmentStart + displacementOfPoint) / totalLength
		}

		return pointsRelativePositions
	}

	private var totalLength: CGFloat {
		let lineWidth = size.width - (2 * .largeRadius)
		let largeArcsLength = CGFloat(numberOfArcs) * arcLength(radius: .largeRadius, partialAngle: .degrees(.halfTurn))
		let segmentsLength = CGFloat(numberOfArcs - 1) * lineWidth
		return (fixedInitialAndFinalLength * 2) + largeArcsLength + segmentsLength
	}

	private var fixedInitialAndFinalLength: CGFloat {
		let smallArcLength = arcLength(radius: .smallRadius, partialAngle: .degrees(.straightAngle))
		let initialHorizontalLineWidth = (size.width / 2) - (.largeRadius + .smallRadius)
		return .bottomAndTopmostLinesUp + smallArcLength + initialHorizontalLineWidth
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

private extension Int {
	var isEven: Bool { self % 2 == 0 }
}

private extension CGRect {
	var startingPoint: CGPoint { .init(x: self.midX, y: self.maxY) }

	init(size: CGSize) { self.init(origin: .zero, size: size) }
}
