//
// Created by Joao Pedro Franco on 16/10/24
//

import SwiftUI

public struct RatingView: View {
	var value: Double
	var count: Int
	
	public init(value: Double, count: Int) {
		self.value = value
		self.count = count
	}

	public var body: some View {
		HStack {
			Image(DesignSystem.Icons.star.rawValue, bundle: .module)
				.renderingMode(.template)
				.resizable()
				.frame(width: 20, height: 20)
				.foregroundColor(.green)
			
			Text(String(format: "%.2f", value))
				.foregroundColor(DesignSystem.Colors.primary)

			Text("(\(count.description))")
				.foregroundColor(DesignSystem.Colors.primary.opacity(0.6))
		}
		.padding(DesignSystem.Spacings.xxs)
	}
}

struct RatingView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			RatingView(value: 100, count: 100)
			RatingView(value: 70.2, count: 23)
			RatingView(value: 1.123123123, count: 45345345435435)
		}
		.previewLayout(.sizeThatFits)
	}
}
