import SwiftUI

enum ScrollElementId {
	case shape
}

struct MilestonesTests: View {
	@State var shouldShowCircles = false
	@State var contentOffset = CGFloat.zero

	var body: some View {
		ZStack(alignment: .top) {
			Color.gray.ignoresSafeArea(.all)
			GeometryReader { proxy in
				ScrollViewReader { scrollProxy in
					ScrollView(showsIndicators: false) {
						let shape = MilestonePath(numberOfArcs: 10, rect: proxy.frame(in: .local))

						ZStack(alignment: .bottom) {
							Color.clear.ignoresSafeArea()
								.frame(height: shape.totalHeight)

							shape
								.stroke(lineWidth: 6)
								.foregroundColor(.white)
								.frame(width: proxy.size.width, height: proxy.size.height)
								.id(ScrollElementId.shape)
								.onAppear {
									scrollProxy.scrollTo(ScrollElementId.shape, anchor: .bottom)
								}

							Circle()
								.fill(.green)
								.frame(width: 30)
								.position(shape.bottommostPoint)

							Circle()
								.fill(.green)
								.frame(width: 30)
								.position(shape.pointAtArc(0))

							Circle()
								.fill(.green)
								.frame(width: 30)
								.position(shape.pointAtArc(1))

							ForEach(
								Array(shape.pointsAtSegment(2, numberOfPoints: 6).enumerated()),
								id: \.offset
							) { _, point in
								Circle()
									.fill(.blue)
									.frame(width: 25)
									.position(point)
							}

							Circle()
								.fill(.green)
								.frame(width: 30)
								.position(shape.topmostPoint)
						}
					}
				}
			}
			.padding(.horizontal)
		}
		.ignoresSafeArea()
	}
}

#Preview {
	MilestonesTests()
}
