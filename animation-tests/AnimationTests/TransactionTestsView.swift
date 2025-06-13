//
//  TransactionTests.swift
//  AnimationTests
import SwiftUI

struct TransactionTestsView: View {
	@State private var isZoomed = false

	var body: some View {
		VStack {
			Button("Toggle Zoom") {
//				var transaction = Transaction(animation: .linear)
//				transaction.disablesAnimations = true
//

				withAnimation(.easeInOut(duration: 3)) {
					isZoomed.toggle()
				}

				isZoomed.toggle()

//				withTransaction(\.animation, .easeOut(duration: 3)) {
//					isZoomed.toggle()
//				}

			}

			Spacer()
				.frame(height: 100)

			Text("Zoom Text 1")
				.font(.title)
				.scaleEffect(isZoomed ? 3 : 1)
				//.animation(.easeInOut(duration: 3), value: isZoomed)

			Spacer()
				.frame(height: 100)

			Text("Zoom Text 2")
				.font(.title)
				.scaleEffect(isZoomed ? 3 : 1)
				//.animation(.easeInOut(duration: 3), value: isZoomed)
//				.transaction { t in
//					t.animation = .easeInOut(duration: 3)
//				}
		}
	}
}

#Preview {
	VStack {
		VStack {
			VStack {
				TransactionTestsView()
					.transaction { t in
						t.animation = nil
					}
			}
		}
	}
	.transaction {
		$0.animation = nil
	}
}
