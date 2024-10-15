//
// Created by Joao Pedro Franco on 17/10/24
//

import SwiftUI

public struct ToastView: View {
	let message: String
	let backgroundColor: Color
	let foregroundColor: Color
	
	public init(
		message: String,
		backgroundColor: Color,
		foregroundColor: Color
	) {
		self.message = message
		self.backgroundColor = backgroundColor
		self.foregroundColor = foregroundColor
	}
	
	public var body: some View {
		VStack {
			Spacer()
			Text(message)
				.padding(DesignSystem.Spacings.xs)
				.background(backgroundColor)
				.foregroundColor(foregroundColor)
				.cornerRadius(DesignSystem.Radius.default)
		}
		.padding(DesignSystem.Spacings.xs)
	}
}

struct ToastView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			ToastView(
				message: "No connection",
				backgroundColor: .red,
				foregroundColor: .white
			)
			
			ToastView(
				message: "Warning",
				backgroundColor: .yellow,
				foregroundColor: .black
			)
		}
		.padding()
	}
}
