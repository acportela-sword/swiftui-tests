import SwiftUI

struct MilestonesTests: View {
	var body: some View {
		ZStack(alignment: .top) {
			Color.gray.ignoresSafeArea(.all)

			VStack(spacing: 60) {
				GeometryReader { proxy in

					ScrollView {
						let shape = MilestonePath(numberOfArcs: 3)
						let path = shape.path(in: .init(x: 0, y: 0, width: proxy.size.width, height: proxy.size.height))
						let startPosition = CGPoint(x: proxy.frame(in: .local).midX, y: proxy.frame(in: .local).maxY)


						ZStack {
							shape.stroke(lineWidth: 6)
								.foregroundColor(.white)
								.frame(width: proxy.size.width, height: proxy.size.height)

							let totalLength = totalPathLength(numberOfArcs: 3, rectWidth: proxy.size.width)
							let badge1 = lengthOf(arc: 0, rectWidth: proxy.size.width) / totalLength
							let badge2 = lengthOf(arc: 1, rectWidth: proxy.size.width) / totalLength
							let badge3 = lengthOf(arc: 2, rectWidth: proxy.size.width) / totalLength

							Circle()
								.fill(.green)
								.frame(width: 30)
								.position(path.trimmedPath(from: 0.0, to: badge1).currentPoint ?? startPosition)

							Circle()
								.fill(.green)
								.frame(width: 30)
								.position(path.trimmedPath(from: 0.0, to: badge2).currentPoint ?? startPosition)

							Circle()
								.fill(.green)
								.frame(width: 30)
								.position(path.trimmedPath(from: 0.0, to: badge3).currentPoint ?? startPosition)

						}
					}
				}
			}
			.padding(.horizontal)
		}
		.ignoresSafeArea()
	}

	func totalPathLength(numberOfArcs: Int, rectWidth: CGFloat) -> CGFloat {
		let lineWidth = rectWidth - (2 * .largeRadius)
		let largeArcsLength = CGFloat(numberOfArcs) * arcLength(radius: .largeRadius, partialAngle: .degrees(.halfTurn))
		let segmentsLength = CGFloat(numberOfArcs - 1) * lineWidth
		return (fixedInitialAndFinalLength(pathWidth: rectWidth) * 2) + largeArcsLength + segmentsLength
	}

	func lengthOf(arc index: Int, rectWidth: CGFloat)  -> CGFloat {
		let lineWidth = rectWidth - (2 * .largeRadius)

		let largeArcsLength = CGFloat(index) * arcLength(radius: .largeRadius, partialAngle: .degrees(.halfTurn))
		let segmentsLength = CGFloat(index) * lineWidth

		// Position at "middle" of the arc
		let ninetyDegreesForward = arcLength(radius: .largeRadius, partialAngle: .degrees(.straightAngle))

		return fixedInitialAndFinalLength(pathWidth: rectWidth)
		+ largeArcsLength
		+ segmentsLength
		+ ninetyDegreesForward
	}

	func arcLength(radius: CGFloat, partialAngle: Angle = .radians(2 * .pi)) -> CGFloat {
		let limitedToOneTurnAngle = min(2 * .pi, partialAngle.radians.magnitude)
		return limitedToOneTurnAngle * radius
	}

	func fixedInitialAndFinalLength(pathWidth: CGFloat) -> CGFloat {
		let smallArcLength = arcLength(radius: .smallRadius, partialAngle: .degrees(.straightAngle))
		let initialHorizontalLineWidth = (pathWidth / 2) - (.largeRadius + .smallRadius)
		return .bottomAndTopmostLinesUp + smallArcLength + initialHorizontalLineWidth
	}
}


#Preview {
	MilestonesTests()
}
