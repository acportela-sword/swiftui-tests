//
//  RotationAndOffset.swift
//  Landmarks
//
//  Created by Antonio Rodrigues on 28/10/24.
//  Copyright © 2024 Apple. All rights reserved.
//

import SwiftUI

struct OffsetAndRotation: View {
	@State private var rotationValue = 0.0

    var body: some View {
		ZStack {
			Color.black.ignoresSafeArea()

			// Can be any view with width = circleGuideDiameter
			// The circle was just to outline the curve
			Circle()
				.stroke(lineWidth: 3.0)
				.foregroundStyle(.blue)
				.background(.black)
				.frame(width: .diameter)

			Image(systemName: "paperplane.fill")
				.foregroundStyle(.yellow)
				// Offset + rotation (in this order) is the key here
				.offset(x: -(.diameter / 2))
				.rotationEffect(.degrees(rotationValue))
				.animation(
					.easeInOut(duration: 1)
					.repeatForever(autoreverses: false)
					.speed(0.5),
					value: rotationValue
				)
				.background(.white)
		}
		.onAppear {
			rotationValue = 360
		}
    }
}

private extension CGFloat {
	static let diameter: Self = 250
}
#Preview {
	OffsetAndRotation()
}
