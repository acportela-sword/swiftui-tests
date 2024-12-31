//
//  RandomSwiftUIView.swift
//  AnimationTests
//
//  Created by Antonio Rodrigues on 15/01/25.
//

import SwiftUI

struct RandomSwiftUIView: View {
    var body: some View {
		GeometryReader { _ in
			VStack {
				Text("HelloWorld")
					.background(Color.yellow)
			}
			.background(Color.blue)
		}
		.background(Color.red)
		//.frame(height: 400)
    }
}

#Preview {
    RandomSwiftUIView()
}
