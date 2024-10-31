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

			// This circle was just to outline the curve
			// It has no effect on the movement
			Circle()
				.stroke(lineWidth: 3.0)
				.foregroundStyle(.blue)
				.background(.black)
				.frame(width: .diameter)

			Circle()
				.frame(width: 40)
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
		}
		.onAppear {
			rotationValue = 180
		}
    }
}

private extension CGFloat {
	static let diameter: Self = 250
}
#Preview {
	OffsetAndRotation()
}
