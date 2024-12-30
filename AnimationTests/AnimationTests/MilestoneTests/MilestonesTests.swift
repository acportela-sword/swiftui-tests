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
				//let _ = print("GeometryReader size \(proxy.frame(in: .local).size)")
				//let _ = print("GeometryReader rect \(proxy.frame(in: .local))")
				ScrollViewReader { scrollProxy in
					ScrollView(showsIndicators: false) {
						let shape = MilestonePath(numberOfArcs: 10, rect: proxy.frame(in: .local))
						//					let path = shape.path(in: .init(x: 0, y: 0, width: proxy.size.width, height: proxy.size.height))
						//					let startPosition = CGPoint(x: proxy.frame(in: .local).minX, y: proxy.frame(in: .local).minY)
						let _ = print("Total Height \(shape.totalHeight)")

						ZStack(alignment: .bottom) {
							Color.clear.ignoresSafeArea()
								.frame(height: shape.totalHeight)

							shape.stroke(lineWidth: 6)
								.foregroundColor(.white)
								.frame(width: proxy.size.width, height: proxy.size.height)
								.id(ScrollElementId.shape)
								.onAppear {
									scrollProxy.scrollTo(ScrollElementId.shape, anchor: .bottom)
								}

//							Circle()
//								.fill(.green)
//								.frame(width: 30)
//								.position(shape.bottommostPoint)

							Circle()
								.fill(.green)
								.frame(width: 30)
								.position(shape.pointOf(arc: 0))
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
