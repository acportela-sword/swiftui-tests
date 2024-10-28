import SwiftUI


struct HikeView: View {
	var hike: Hike
	@State private var showDetail = false


	var body: some View {
		VStack {
			//LinesExample()

			HStack {
				HikeGraph(hike: hike, path: \.elevation)
					.frame(width: 50, height: 30)


				VStack(alignment: .leading) {
					Text(hike.name)
						.font(.headline)
					Text(hike.distanceText)
				}


				Spacer()


				Button {
					//showDetail.toggle()
					withAnimation(.easeInOut(duration: 3)) {
						showDetail.toggle()
					}
				} label: {
					Label("Graph", systemImage: "chevron.right.circle")
						.labelStyle(.iconOnly)
						.imageScale(.large)
						.rotationEffect(.degrees(showDetail ? 90 : 0))
						//.animation(nil, value: showDetail)
						.scaleEffect(showDetail ? 2 : 1)
						.padding()
						//.animation(.easeInOut, value: showDetail)
				}
			}


//			if showDetail {
//				HikeDetail(hike: hike)
//					.transition(.moveAndFade)
//			}

			if showDetail {
				Circle()
					.fill(.blue)
					.frame(width: 50)
					.transition(RotatingFadeTransition())
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

struct RotatingFadeTransition: Transition {
	func body(content: Content, phase: TransitionPhase) -> some View {
		content
		.opacity(phase.isIdentity ? 1.0 : 0.0)
		.transformEffect(phase.transformation)
		//.rotationEffect(phase.rotation)
	}
}
extension TransitionPhase {
	fileprivate var rotation: Angle {
		switch self {
		case .willAppear: return .degrees(30)
		case .identity: return .zero
		case .didDisappear: return .degrees(30)
		}
	}

	fileprivate var transformation: CGAffineTransform {
		switch self {
		case .willAppear: return .init(a: 10, b: 20, c: 30, d: 100, tx: 200, ty: 11)
		case .identity: return .identity
		case .didDisappear: return .init(scaleX: 1.5, y: 1.5)
		}
	}
}

struct Line1: Shape {
	var coordinate: CGFloat

	var animatableData: CGFloat {
		get { coordinate }
		set { coordinate = newValue }
	}

	func path(in rect: CGRect) -> Path {
		Path { path in
			path.move(to: .zero)
			path.addLine(to: CGPoint(x: coordinate, y: coordinate))
		}
	}
}


struct Line2D: Shape {
	var x: CGFloat
	var y: CGFloat

	var animatableData: AnimatablePair<CGFloat, CGFloat> {
		get { AnimatablePair(x, y) }
		set {
			x = newValue.first
			y = newValue.second
		}
	}

	func path(in rect: CGRect) -> Path {
		Path { path in
			path.move(to: .zero)
			path.addLine(to: CGPoint(x: x, y: y))
		}
	}
}

struct LinesExample: View {
	@State private var coordinate: CGFloat = .zero
	@State private var point: CGPoint = .zero

	var body: some View {

		VStack(spacing: 16) {
//			Circle()
//				.fill(.red)
//				.frame(width: 100)

			Line1(coordinate: coordinate)
				.stroke(Color.red)
				.animation(.linear(duration: 1).repeatForever(), value: coordinate)

			Line2D(x: point.x, y: point.y)
				.stroke(Color.blue)
				.animation(.linear(duration: 1).repeatForever(), value: point)
		}
		.onAppear {
			self.coordinate = 100
			self.point.x = 100
			self.point.y = 200
		}
	}
}

#Preview {
	VStack {
		HikeView(hike: ModelData().hikes[0])
			.padding()
		Spacer()
	}
}
