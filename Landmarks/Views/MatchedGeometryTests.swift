//
//  MatchedGeometryTests.swift
//  Landmarks
//
//  Created by Antonio Rodrigues on 28/10/24.
//  Copyright © 2024 Apple. All rights reserved.
//

import SwiftUI

enum Step: String, CaseIterable {
	case foo = "Foo"
	case bar = "Bar"
	case baz = "Baz"

	var diameter: CGFloat {
		switch self {
		case .foo: 60
		case .bar: 120
		case .baz: 400
		}
	}

	var rotationAngle: Double {
		switch self {
		case .foo: 30
		case .bar: 90
		case .baz: 120
		}
	}

	var rotationOffset: CGFloat {
		switch self {
		case .foo: 30
		case .bar: 90
		case .baz: 120
		}
	}
}

struct MatchedGeometryTests: View {
	@Namespace var animation: Namespace.ID
	@Namespace var circle: Namespace.ID

	@State var step: Step = .baz
	@State var rotationAngle: Double = 0.0

    var body: some View {
		VStack {
			title

			// Findings:
			// 1- If some step has different "layer depth" (ie: one is inside a container and the other not)
			// Transition might not be smooth.
			// The problem seems to happen when the source is not wrapped in a VStack/HStack but the destination is
			// Even if one view is in a HStack and the other in a VStack the transition is smooth
			// 2- Always have only one "isSoure = true" (documentation)
			switch step {
			case .foo:
				fooStepView
			case .bar:
				barStepView
			case .baz:
				backgroundCircle(for: .baz)
					.frame(width: step.diameter)
					.padding(.top, 200)
					.animation(.easeInOut(duration: 4), value: rotationAngle)
			}

			Spacer()

			button
		}
		.background(Color.gray.ignoresSafeArea(.all))
    }

	private func backgroundCircle(for currentStep: Step) -> some View {
		Circle()
			.fill(.blue)
			.matchedGeometryEffect(
				id: circle,
				in: animation,
				properties: .frame,
				isSource: step == currentStep
			)
	}

	private var fooStepView: some View {
		VStack(spacing: .zero) {
			RoundedRectangle(cornerSize: .init(width: 8, height: 8))
				.frame(width: 80, height: 100)
				.foregroundColor(.white)
				.zIndex(0)

			backgroundCircle(for: .foo)
				.frame(width: step.diameter)
				.padding(.top, -(Step.foo.diameter / 2))
				.padding(.leading, 40)
				.zIndex(1)
		}
		.background(.red)
	}

	private var barStepView: some View {
		VStack(spacing: .zero) {
			Spacer()
			backgroundCircle(for: .bar)
				.frame(width: step.diameter)
				.padding(.top, -(Step.bar.diameter / 2))
				.padding(.leading, 80)
			Spacer()
		}
	}

	private var button: some View {
		Button(
			action: {
				let allSteps = Step.allCases
				let index = allSteps.firstIndex(of: step) ?? 0

				withAnimation(.easeInOut(duration: 2)) {
					step = allSteps[safeIndex: index + 1] ?? .foo
				}
				rotationAngle = step.rotationAngle
			}
		) {
			ZStack {
				RoundedRectangle(cornerSize: .init(width: 8, height: 8))
					.frame(width: 120, height: 48)
					.frame(maxWidth: .infinity)
				Text("NeXTSTEP")
					.foregroundStyle(.white)
					.font(.body.bold())
			}
		}
		.padding(.top)
	}

	private var title: some View {
		Text("Step: \(step.rawValue)")
			.font(.title2.bold())
			.foregroundStyle(.white)
			.padding(.top, 16)
			.padding(.bottom, 32)
			.animation(.none, value: step)
	}
}

#Preview {
    MatchedGeometryTests()
}

extension Array {
	public subscript(safeIndex index: Int) -> Element? {
		guard index >= 0, index < endIndex else {
			return nil
		}
		return self[index]
	}
}
