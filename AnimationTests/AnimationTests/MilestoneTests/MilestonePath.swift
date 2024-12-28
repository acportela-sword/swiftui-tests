import SwiftUI

struct MilestonePath: Shape {
	let numberOfBadges: Int

	func path(in rect: CGRect) -> Path {
		let lineWidth = rect.width - (2 * .largeRadius)
		let initialLineWidth = (rect.width / 2) - (.largeRadius + .smallRadius)

		var path = Path()

		for index in 0..<(numberOfBadges / 2) {
			if index == 0 {
				path.move(to: rect.startingPoint)
				path.addLineUp(length: .initialLineUpLength)
				path.addInitialArc()
				path.addRightToLeftLine(length: initialLineWidth)
			}

			path.addLeftArc()
			path.addLeftToRightLine(length: lineWidth)
			path.addRightArc()
			path.addRightToLeftLine(length: lineWidth)
		}

		return path
	}
}
