import SwiftUI

struct ShapeTests: View {
	@State var rotation: Double = 0.0
	@State private var coordinate: CGFloat = .zero
	@State private var point: CGPoint = .zero


    var body: some View {
		ZStack(alignment: .top) {
			Color.gray.ignoresSafeArea(.all)

			VStack(alignment: .leading, spacing: 60) {
				Arc(rotation: rotation)
					.stroke(lineWidth: 3)
					.foregroundColor(.white)
					.frame(width: 100, height: 100)
					.background(Color.green)
					.animation(.easeInOut(duration: 4).repeatForever(autoreverses: false), value: rotation)

				Line1D(coordinate: coordinate)
					.stroke(lineWidth: 3)
					.frame(width: 100, height: 100)
					.foregroundColor(.white)
					.background(Color.green)
					.animation(.linear(duration: 2).repeatForever(), value: coordinate)

				Line2D(x: point.x, y: point.y)
					.stroke(lineWidth: 3)
					.frame(width: 100, height: 100)
					.foregroundColor(.white)
					.background(Color.green)
					.animation(.linear(duration: 1).repeatForever(), value: point)
			}
			.padding(.top, 32)
		}
		.onAppear {
			rotation = 360
			self.coordinate = 100
			self.point.x = 150
			self.point.y = 150
		}
    }
}

struct Arc: Shape {
	var rotation: Double = 0.0

	// You can also use an AnimatablePair for two dimensions
	var animatableData: Double {
		get { rotation }
		set { rotation = newValue }
	}

	func path(in rect: CGRect) -> Path {
		var path = Path()
		path.addArc(
			center: .init(x:  rect.midX, y: rect.midY),
			radius: rect.width / 2,
			startAngle: .degrees(180),
			endAngle: .degrees(rotation + 180),
			clockwise: false
		)
		return path
	}
}

struct Line1D: Shape {
	var coordinate: CGFloat

	var animatableData: CGFloat {
		get { coordinate }
		set { coordinate = newValue }
	}

	func path(in rect: CGRect) -> Path {
		Path { path in
			path.move(to: rect.origin)
			path.addLine(to: CGPoint(x: .zero, y: coordinate))
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
			path.move(to:  rect.origin)
			path.addLine(to: CGPoint(x: x, y: y))
		}
	}
}

#Preview {
    ShapeTests()
}
