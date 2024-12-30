import SwiftUI

struct MilestonePath: Shape {
	/// Number of arcs, excluding bottom and top small arcs
	let numberOfArcs: Int

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
}

private extension Int {
	var isEven: Bool { self % 2 == 0 }
}
