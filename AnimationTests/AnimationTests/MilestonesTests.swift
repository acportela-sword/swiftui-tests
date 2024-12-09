import SwiftUI

struct MilestonesTests: View {
	var body: some View {
		ZStack(alignment: .top) {
			Color.gray.ignoresSafeArea(.all)

			VStack(spacing: 60) {
				GeometryReader { proxy in
					ScrollView {
						// Note: The "neatness" of using a shape instead of plugging in the Path directly might not be worth.
						// We have to align the badges and the milestones marks to parts of the path, and when using Shapes we
						// isolate the path from the outside. We would have to manually offset each badge to match their position
						// To the paths.
						// Nevertheless, I used a Shape here because its easier to extract the path later if needed.
						MilestonePath(numberOfBadges: 6)
							.stroke(lineWidth: 6)
							.foregroundColor(.white)
							.padding(.horizontal, 4)
							.frame(width: proxy.size.width, height: proxy.size.height)
					}
				}
			}
			.padding(.horizontal)
		}
		.ignoresSafeArea()
	}
}

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

private extension Path {
	var currentX: CGFloat { self.currentPoint?.x ?? .zero }
	var currentY: CGFloat { self.currentPoint?.y ?? .zero }

	mutating func addInitialArc() {
		addRelativeArc(
			center: .init(x:  currentX - .smallRadius, y: currentY),
			radius: .smallRadius,
			startAngle: .degrees(.zero),
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

private extension CGRect {
	var startingPoint: CGPoint { .init(x: self.midX, y: self.maxY) }
}

private extension Double {
	static let straightAngle: Self = 90
	static let halfTurn: Self = 180
}

private extension CGFloat {
	static let initialLineUpLength: Self = 50
	static let smallRadius: Self = 30
	static let largeRadius: Self = 60
}

#Preview {
	MilestonesTests()
}
