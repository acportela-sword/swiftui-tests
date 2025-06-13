//
//  RandomSwiftUIView.swift
//  AnimationTests
//
//  Created by Antonio Rodrigues on 15/01/25.
//

import SwiftUI

struct Names: Identifiable {
	let id: String
}

struct RandomSwiftUIView: View {
	let list: [Names] = [.init(id: "foo"), .init(id: "foo"), .init(id: "foo"), .init(id: "foo")]
    var body: some View {
		List {
			ForEach(list) {
				Text($0.id)
			}
		}

    }
}

#Preview {
    RandomSwiftUIView()
}
