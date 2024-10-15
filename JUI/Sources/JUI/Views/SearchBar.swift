//
// Created by Joao Pedro Franco on 24/09/24
//

import SwiftUI

/// A custom search bar view.
///
/// Since there is no native search bar in SwiftUI, this view provides a custom implementation.
/// It accepts a `Binding<String>` to manage the search input text dynamically.
public struct SearchBar: View {
	let placeholder: String
	@Binding var text: String
	
	public init(placeholder: String = "Search...", text: Binding<String>) {
		self.placeholder = placeholder
		self._text = text
	}
	
	public var body: some View {
		TextField(placeholder, text: $text)
			.padding(DesignSystem.Spacings.xs)
			.background(Color(.systemGray6))
			.cornerRadius(DesignSystem.Radius.default)
			.padding(.horizontal, DesignSystem.Spacings.xs)
	}
}

struct SearchBar_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			SearchBar(text: .constant(""))
			SearchBar(placeholder: "Another placeholder", text: .constant(""))
		}
	}
}
