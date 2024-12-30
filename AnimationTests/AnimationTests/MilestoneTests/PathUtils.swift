import SwiftUI

extension Path {
	var currentX: CGFloat { self.currentPoint?.x ?? .zero }
	var currentY: CGFloat { self.currentPoint?.y ?? .zero }

	mutating func addBottommostArc() {
		addRelativeArc(
			center: .init(x:  currentX - .smallRadius, y: currentY),
			radius: .smallRadius,
			startAngle: .degrees(.zero),
			delta: .degrees(-.straightAngle)
		)
	}

	mutating func addTopmostArcFromRight() {
		addRelativeArc(
			center: .init(x:  currentX, y: currentY - .smallRadius),
			radius: .smallRadius,
			startAngle: .degrees(.straightAngle),
			delta: .degrees(.straightAngle)
		)
	}

	mutating func addTopmostArcFromLeft() {
		addRelativeArc(
			center: .init(x:  currentX, y: currentY - .smallRadius),
			radius: .smallRadius,
			startAngle: .degrees(.straightAngle),
			delta: .degrees(-.straightAngle)
		)
	}

	mutating func addLeftArc() {
		addRelativeArc(
			center: .init(x:  currentX, y: currentY - .largeRadius),
			radius: .largeRadius,
			startAngle: .degrees(.straightAngle), // Always 90
			delta: .degrees(.halfTurn) // Positive angle: arc is on the left side
		)
	}

	mutating func addRightArc() {
		addRelativeArc(
			center: .init(x: currentX, y: currentY - .largeRadius),
			radius: .largeRadius,
			startAngle: .degrees(.straightAngle),
			delta: .degrees(-.halfTurn) // Negative angle: arc is on the right side
		)
	}

	mutating func addLeftToRightLine(length: CGFloat) {
		addLine(to: CGPoint(x: currentX + length, y: currentY))
	}

	mutating func addRightToLeftLine(length: CGFloat) {
		addLine(to: CGPoint(x: currentX - length, y: currentY))
	}

	mutating func addLineUp(length: CGFloat) {
		addLine(to: CGPoint(x: currentX, y: currentY - length))
	}
}

extension CGRect {
	var startingPoint: CGPoint { .init(x: self.midX, y: self.maxY) }
}

extension Double {
	static let straightAngle: Self = 90
	static let halfTurn: Self = 180
}

extension CGFloat {
	static let bottomAndTopmostLinesUp: Self = 50
	static let smallRadius: Self = 30
	static let largeRadius: Self = 60
}
