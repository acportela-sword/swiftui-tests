import SwiftUI

public struct ScrollViewTrackingOffset<Content>: View where Content: View {
	private let axes: Axis.Set
	private let showIndicators: Bool
	private let contentNeedsStack: Bool
	private let trackForShadow: Bool
	@Binding var contentOffset: CGFloat
	private let content: (ScrollViewProxy) -> Content

	public init(
		_ axes: Axis.Set = .vertical,
		showIndicators: Bool = false,
		contentNeedsStack: Bool = true,
		trackForShadow: Bool = true,
		contentOffset: Binding<CGFloat>,
		@ViewBuilder content: @escaping (ScrollViewProxy) -> Content
	) {
		self.axes = axes
		self.showIndicators = showIndicators
		self.contentNeedsStack = contentNeedsStack
		self.trackForShadow = trackForShadow
		self._contentOffset = contentOffset
		self.content = content
	}

	public var body: some View {
		GeometryReader { outsideProxy in
			ScrollViewReader { scrollViewProxy in
				ScrollView(axes, showsIndicators: showIndicators) {

					ZStack(alignment: self.axes == .vertical ? .top : .leading) {
						GeometryReader { insideProxy in
							Color.clear
								.preference(
									key: OffsetPreferenceKey.self,
									value: [
										self.calculateContentOffset(
											fromOutsideProxy: outsideProxy,
											insideProxy: insideProxy
										)
									]
								)
						}

						if contentNeedsStack {
							LazyVStack {
								self.content(scrollViewProxy)
							}
						} else {
							self.content(scrollViewProxy)
						}
					}
					.onPreferenceChange(OffsetPreferenceKey.self) { value in
						guard trackForShadow else {
							self.contentOffset = value.first ?? .zero
							return
						}

						if let firstValue = value.first?.rounded() {
							if self.contentOffset > .zero && firstValue <= .zero {
								self.contentOffset = .zero
							} else if self.contentOffset <= .zero && firstValue > .zero {
								self.contentOffset = firstValue
							}
						}
					}
				}
			}
		}
	}

	private func calculateContentOffset(fromOutsideProxy outsideProxy: GeometryProxy, insideProxy: GeometryProxy) -> CGFloat {
		if axes == .vertical {
			return outsideProxy.frame(in: .global).minY.rounded(.towardZero)
			- insideProxy.frame(in: .global).minY.rounded(.towardZero)
		}
		return outsideProxy.frame(in: .global).minX.rounded(.towardZero)
		- insideProxy.frame(in: .global).minX.rounded(.towardZero)
	}
}

struct OffsetPreferenceKey: PreferenceKey {
	static var defaultValue: [CGFloat] = [0]

	static func reduce(value: inout [CGFloat], nextValue: () -> [CGFloat]) {
		value.append(contentsOf: nextValue())
	}
}
