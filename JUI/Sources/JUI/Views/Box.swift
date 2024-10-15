//
// Created by Joao Pedro Franco on 17/10/24
//

import SwiftUI

public struct Box<Content: View>: View {
	private var contentView: () -> Content
	
	public init(@ViewBuilder contentView: @escaping () -> Content) {
		self.contentView = contentView
	}
	
	public var body: some View {
		VStack {
			contentView()
				.padding(DesignSystem.Spacings.xs)
		}
		.background(DesignSystem.Colors.background)
		.cornerRadius(DesignSystem.Radius.default)
		.shadow(
			color: DesignSystem.Colors.primary.opacity(0.6),
			radius: 2, x: 0, y: 0
		)
	}
}

struct Box_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			Box {
				Text("Inner View")
			}
			.padding()
		}
		.previewLayout(.sizeThatFits)
	}
}
