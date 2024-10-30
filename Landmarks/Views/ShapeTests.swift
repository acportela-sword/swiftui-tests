//
//  ShapeTests.swift
//  Landmarks
//
//  Created by Antonio Rodrigues on 29/10/24.
//  Copyright © 2024 Apple. All rights reserved.
//

import SwiftUI

struct MyShape: Shape {
	var rotation: Double = 0.0
	var position: CGPoint = .zero

	// For example, the equation of the circle centered at \[(\blueD 1,\maroonD 2)\] with radius \[\goldD 3\] is \[(x-\blueD 1)^2+(y-\maroonD 2)^2=\goldD 3^2\]. This is its expanded equation:

	var animatableData: Double {
		get { rotation }
		set { rotation = newValue }
	}

//	func path(in rect: CGRect) -> Path {
//		var path = Path()
//		path.addArc(
//			center: .init(x:  rect.midX, y: rect.midY),
//			radius: rect.width / 2,
//			startAngle: .degrees(180),
//			endAngle: .degrees(rotation + 180),
//			clockwise: false
//		)
//		return path
//	}

	func path(in rect: CGRect) -> Path {
		var path = Path()
		
		path.addArc(
			center: .init(x:  rect.minX, y: rect.midY),
			radius: 2,
			startAngle: .degrees(0),
			endAngle: .degrees(rotation),
			clockwise: false
		)

		return path.fill(.red).shape
	}
}

struct ShapeTests: View {
	@State var rotation: Double = 0.0

    var body: some View {
		VStack {
			VStack {
				MyShape(rotation: rotation)
					.stroke(lineWidth: 3)
					.frame(width: 100, height: 100)
					.background(.red)

				Circle()
					.frame(width: 10)
					.offset(x: 50, y: 50)
					.rotationEffect(.degrees(rotation))
					.background(.blue)

				Rectangle()
					.frame(width: 10, height: 30)
			}
		}
		.onAppear {
			withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: false)) {
				rotation = 360
			}
		}
    }
}

#Preview {
    ShapeTests()
}
