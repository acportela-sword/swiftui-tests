import SwiftUI

struct MilestonesTests: View {
	var body: some View {
		ZStack(alignment: .top) {
			Color.gray.ignoresSafeArea(.all)

			VStack(spacing: 60) {
				GeometryReader { proxy in

					ScrollView {
						let shape = MilestonePath(numberOfBadges: 6)
						let path = shape.path(in: .init(x: 0, y: 0, width: proxy.size.width, height: proxy.size.height))
						let startPosition = CGPoint(x: proxy.frame(in: .local).midX, y: proxy.frame(in: .local).maxY)


						ZStack {
							shape.stroke(lineWidth: 6)
								.foregroundColor(.white)
								.frame(width: proxy.size.width, height: proxy.size.height)

//							let flattened = path.cgPath.flattened(threshold: .infinity)
//							let components = flattened.componentsSeparated().first!
//							let _ = print("Components \(components)")
//							let _ = print("Flattened \(flattened)")
//
//							Path(flattened)
//								.stroke(lineWidth: 3)
//								.foregroundStyle(Color.blue)

//							let components = path.cgPath.componentsSeparated()
//							let _ = print("Count \(components.count)")
//							Path(components[0])
//								.stroke(lineWidth: 3)
//								.foregroundStyle(Color.red)

							let totalLength = calculateTotalLength(numberOfBadges: 6, rectWidth: proxy.size.width)
							let badge1 = positionOfArc(index: 0, rectWidth: proxy.size.width) / totalLength
							let badge2 = positionOfArc(index: 1, rectWidth: proxy.size.width) / totalLength
							let badge3 = positionOfArc(index: 2, rectWidth: proxy.size.width) / totalLength

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

	func calculateTotalLength(numberOfBadges: Int, rectWidth: CGFloat) -> CGFloat {
		let lineWidth = rectWidth - (2 * .largeRadius)

		let largeArcsLength = CGFloat(numberOfBadges) * arcLength(radius: .largeRadius, partialAngle: .degrees(.halfTurn))
		let segmentsLength = CGFloat(numberOfBadges) * lineWidth

		// TODO: Add final path after adjusting MilesonePath
		return fixedInitialAndFinalLength(pathWidth: rectWidth) + largeArcsLength + segmentsLength
	}

	func positionOfArc(index: Int, rectWidth: CGFloat)  -> CGFloat {
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
		return .initialLineUpLength + smallArcLength + initialHorizontalLineWidth
	}
}


#Preview {
	MilestonesTests()
}
