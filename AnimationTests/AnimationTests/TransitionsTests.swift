import SwiftUI

struct TransitionsTests: View {
	@State private var showSecondRectangle = false

	var body: some View {
		VStack(spacing: 40) {
			Button {
				withAnimation(.easeInOut(duration: 3)) {
					showSecondRectangle.toggle()
				}

			} label: {
				Rectangle()
					.stroke(lineWidth: 5)
					.frame(width: 50, height: 50)
					.labelStyle(.iconOnly)
					.imageScale(.large)
					.rotationEffect(.degrees(showSecondRectangle ? 90 : 0))
					// Cancel previous animations
					//.animation(nil, value: showSecondRectangle)
					.scaleEffect(showSecondRectangle ? 2 : 1)
					.padding()
					//.animation(.easeInOut, value: showSecondSquare)
			}

			if showSecondRectangle {
				Rectangle()
					.stroke(lineWidth: 5)
					.foregroundStyle(.red)
					.frame(width: 50, height: 50)
					.transition(.moveAndFade)
					// Or use a custom transition
					//.transition(RotatingFadeTransition())
			}
		}
	}
}

extension AnyTransition {
	static var moveAndFade: AnyTransition {
		.asymmetric(
			insertion: .move(edge: .bottom).combined(with: .opacity),
			removal: .move(edge: .trailing).combined(with: .opacity)
		)
	}
}

@available(iOS 17.0, *)
struct RotatingFadeTransition: Transition {
	func body(content: Content, phase: TransitionPhase) -> some View {
		content
		.opacity(phase.isIdentity ? 1.0 : 0.0)
		.rotationEffect(phase.rotation)
	}
}

@available(iOS 17.0, *)
extension TransitionPhase {
	fileprivate var rotation: Angle {
		switch self {
		case .willAppear: return .degrees(90)
		case .identity: return .zero
		case .didDisappear: return .degrees(90)
		}
	}

	fileprivate var transformation: CGAffineTransform {
		switch self {
		case .willAppear: return .identity //.init(a: 10, b: 20, c: 30, d: 100, tx: 200, ty: 11)
		case .identity: return .identity
		case .didDisappear: return .init(scaleX: 1.5, y: 1.5)
		}
	}
}

#Preview {
	VStack {
		TransitionsTests()
		Spacer()
	}
}
