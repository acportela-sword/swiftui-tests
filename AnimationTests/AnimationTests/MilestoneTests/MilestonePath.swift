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

	var bottommostPointInPath: CGPoint {
		let path = self.path(in: .init(size: size))
		return path.pointAt(length: 0, fallback: initialPoint)
	}

	var topmostPointInPath: CGPoint {
		let path = self.path(in: .init(size: size))
		return path.pointAt(length: 1, fallback: initialPoint)
	}

	/// Returns the point of the path located in the "middle" if the arc of idex `
	/// Zero based index
	func pointOf(arc index: Int) -> CGPoint {
		let path = self.path(in: .init(size: size))

		let point = path.pointAt(length: relativeLengthOf(arc: index), fallback: initialPoint)

		// If the path goes beyond screen size, trimmedPath doesn't work properly
		// We need to compensate by adding the the part (negative) that stays off screen
		let topmostYInPath = path.pointAt(length: 1, fallback: initialPoint).y
		let adjustedPoint = CGPoint(x: point.x, y: point.y + abs(topmostYInPath))

		return topmostYInPath < 0 ? adjustedPoint : point
	}

	private func relativeLengthOf(arc index: Int)  -> CGFloat {
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
}

private extension Int {
	var isEven: Bool { self % 2 == 0 }
}

private extension CGRect {
	var startingPoint: CGPoint { .init(x: self.midX, y: self.maxY) }

	init(size: CGSize) { self.init(origin: .zero, size: size) }
}
