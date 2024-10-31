import SwiftUI

struct MatchedGeometryTests: View {
	@Namespace var animation: Namespace.ID
	@Namespace var circle: Namespace.ID

	@State var step: Step = .foo

    var body: some View {
		ZStack {
			Color.gray.ignoresSafeArea(.all)
			
			VStack {
				title

				switch step {
				case .foo:
					fooStepView
				case .bar:
					barStepView
				case .baz:
					backgroundCircle(for: .baz)
						.frame(width: step.diameter)
						.padding(.top, 200)
				case .delta:
					// What if we don't have any ball in a particular step?
					EmptyView()
				}

				Spacer()

				button
			}
		}
    }

	private func backgroundCircle(for currentStep: Step) -> some View {
		Circle()
			.fill(.red)
			.matchedGeometryEffect(
				id: circle,
				in: animation,
				properties: .frame,
				// - Only keep one "isSource = true" (check documentation)
				isSource: step == currentStep
			)
	}

	private var bazStepView: some View {
		backgroundCircle(for: .baz)
			.frame(width: step.diameter)
			.padding(.top, 200)
	}

	private var fooStepView: some View {
		VStack(spacing: .zero) {
			RoundedRectangle(cornerSize: .init(width: 8, height: 8))
				.frame(width: 80, height: 100)
				.foregroundColor(.white)
				.zIndex(1)

			backgroundCircle(for: .foo)
				.frame(width: step.diameter)
				.padding(.top, -(Step.foo.diameter / 2))
				.padding(.leading, 70)
		}
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
			}
		) {
			ZStack {
				RoundedRectangle(cornerSize: .init(width: 8, height: 8))
					.frame(width: 120, height: 48)
					.frame(maxWidth: .infinity)
				Text("Next")
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

enum Step: String, CaseIterable {
	case foo = "Foo"
	case bar = "Bar"
	case baz = "Baz"
	case delta = "Delta"

	var diameter: CGFloat {
		switch self {
		case .foo: 60
		case .bar: 120
		case .baz: 400
		case .delta: 80
		}
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
