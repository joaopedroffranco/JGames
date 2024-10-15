//
// Created by Joao Pedro Franco on 24/09/24
//

import SwiftUI

/// A view representing a simple box with a title and value.
///
/// Displays a title on the left and its corresponding value on the right.
/// Both `backgroundColor` and `foregroundColor` can be customized.
public struct Box: View {
	let title: String
	let value: String
	let backgroundColor: Color
	let foregroundColor: Color

	public init(
		title: String,
		value: String,
		backgroundColor: Color,
		foregroundColor: Color
	) {
		self.title = title
		self.value = value
		self.backgroundColor = backgroundColor
		self.foregroundColor = foregroundColor
	}
	
	public var body: some View {
		HStack {
			Text(title)
				.font(DesignSystem.Fonts.section)
				.foregroundColor(foregroundColor)
				.padding(DesignSystem.Spacings.xs)
			
			Spacer()
			
			Text(value)
				.font(DesignSystem.Fonts.default)
				.foregroundColor(foregroundColor)
				.padding(DesignSystem.Spacings.xs)
		}
		.padding(.horizontal, DesignSystem.Spacings.xs)
		.background(backgroundColor)
		.cornerRadius(DesignSystem.Radius.default)
	}
}

struct Box_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			Box(
				title: "Title",
				value: "Value",
				backgroundColor: .white,
				foregroundColor: .black
			)
			Box(
				title: "Title",
				value: "Value",
				backgroundColor: .black,
				foregroundColor: .white
			)
		}
		.previewLayout(.sizeThatFits)
	}
}
