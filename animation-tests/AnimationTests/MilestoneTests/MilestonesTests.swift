import SwiftUI

enum ScrollElementId {
	case shape
}

struct MilestonesTests: View {
	@State var shouldShowCircles = false
	@State var contentOffset = CGFloat.zero
	@State var shouldBlur = false

	var body: some View {
		ZStack(alignment: .top) {
			Color.gray.ignoresSafeArea(.all)
			GeometryReader { proxy in
				ScrollViewReader { scrollProxy in
					ScrollView(showsIndicators: false) {
						//let path = shape.path(in: pathRect)

						VStack(spacing: 32) {
							ZStack(alignment: .bottom) {
								let pathRect = pathRect(from: proxy)
								let arcs = 14
								let shape = MilestonePath(numberOfArcs: arcs, rect: pathRect)
								Color.gray.ignoresSafeArea()
									.frame(height: shape.totalHeight)

								shape
									.stroke(.white, lineWidth: 8)
									.frame(width: pathRect.width, height: proxy.size.height)
									.id(ScrollElementId.shape)
									.onAppear {
										scrollProxy.scrollTo(ScrollElementId.shape, anchor: .bottom)
									}
									.blur(radius: shouldBlur ? .blurRadius : .zero)

								shape.partialPathUpTo(.lastTurn)
									.stroke(.yellow, lineWidth: 8)
									.frame(width: pathRect.width, height: proxy.size.height)
									.blur(radius: shouldBlur ? .blurRadius : .zero)

								shape.partialPathUpTo(.arc(2))
									.stroke(.blue, lineWidth: 8)
									.frame(width: pathRect.width, height: proxy.size.height)
									.blur(radius: shouldBlur ? .blurRadius : .zero)

								shape.partialPathUpTo(.startOfSegment(0))
									.stroke(.purple, lineWidth: 8)
									.frame(width: pathRect.width, height: proxy.size.height)
									.blur(radius: shouldBlur ? .blurRadius : .zero)

								shape.partialPathUpTo(.segment(0, dividedIn: 4, positionedAt: 3))
									.stroke(.pink, lineWidth: 8)
									.frame(width: pathRect.width, height: proxy.size.height)
									.blur(radius: shouldBlur ? .blurRadius : .zero)

								shape.partialPathUpTo(.firstTurn)
									.stroke(.black, lineWidth: 4)
									.frame(width: pathRect.width, height: proxy.size.height)
									.blur(radius: shouldBlur ? .blurRadius : .zero)

								Circle()
									.fill(.green)
									.frame(width: .milestoneDiameter)
									.position(shape.bottommostPoint.shiftedToCenterMilestone)
									.blur(radius: shouldBlur ? .blurRadius : .zero)

								Circle()
									.fill(.green)
									.frame(width: .milestoneDiameter)
									.position(shape.pointAt(.arc(4)).shiftedToCenterMilestone)
									.blur(radius: shouldBlur ? .blurRadius : .zero)

								Circle()
									.fill(.green)
									.frame(width: .milestoneDiameter)
									.position(shape.pointAt(.arc(1)).shiftedToCenterMilestone)
									.blur(radius: shouldBlur ? .blurRadius : .zero)


								ForEach(
									Array(shape.pointsAtSegment(2, dividedIn: 3).enumerated()),
									id: \.offset
								) { _, point in
									Circle()
										.fill(.blue)
										.frame(width: .subMilestoneDiameter)
										.position(point.shiftedToCenterMilestone)
										.blur(radius: shouldBlur ? .blurHalfRadius : .zero)
								}

								Circle()
									.fill(.green)
									.frame(width: .milestoneDiameter)
									.position(shape.topmostPoint.shiftedToCenterMilestone)
									.blur(radius: shouldBlur ? .blurRadius : .zero)
							}
							.frame(width: proxy.size.width)

							Rectangle()
								.padding(.horizontal, 24)
								.clipShape(.rect(cornerRadius: 16))
								.frame(width: proxy.size.width, height: 80)
						}

					}
				}
			}
			//.padding(.horizontal)
		}
		.ignoresSafeArea()
	}

	private func pathRect(from proxy: GeometryProxy) -> CGRect {
		let rect = proxy.frame(in: .local)
		return CGRect(
			origin: .zero,
			size: .init(width: rect.width - .pathHorizontalPadding, height: rect.height)
		)
	}
}

private extension CGPoint {
	// The position modifier positions at parent's coordinate.
	//We need to adjust for that since MilestonePath return's a point in its own coordinate system
	var shiftedToCenterMilestone: Self {
		.init(x: self.x + (.pathHorizontalPadding / 2), y: self.y)
	}
}

private extension CGFloat {
	static let defaultPadding: Self = 16
	static let milestoneDiameter: Self = 60
	static let subMilestoneDiameter: Self = 24
	static let pathHorizontalPadding: Self = 48
	static let blurRadius: Self = 4
	static let blurHalfRadius: Self = 4
}

#Preview {
	MilestonesTests()
}
