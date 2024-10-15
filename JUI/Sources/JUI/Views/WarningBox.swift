//
// Created by Joao Pedro Franco on 25/09/24
//

import SwiftUI

/// A custom view for displaying a warning message.
///
/// Shows a warning message that includes a headline and a descriptive text.
public struct WarningBox: View {
	let headline: String
	let message: String
	
	public init(headline: String, message: String) {
		self.headline = headline
		self.message = message
	}
	
	public var body: some View {
		HStack {
			VStack(alignment: .leading) {
				Text(headline)
					.font(DesignSystem.Fonts.section)
					.foregroundColor(DesignSystem.Colors.dark)
				
				Text(message)
					.font(DesignSystem.Fonts.small)
					.foregroundColor(DesignSystem.Colors.dark)
			}
			Spacer()
		}
		.padding(DesignSystem.Spacings.xs)
		.background(DesignSystem.Colors.yellow)
		.cornerRadius(DesignSystem.Radius.default)
	}
}

struct WarningBox_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			WarningBox(
				headline: "Warning",
				message: "A Flood Warning means that flooding is imminent or occurring. All\ninterested parties should take necessary precautions immediately.\nMotorists should not attempt to drive around barricades or drive\ncars through flooded areas.\nCaution is urged when walking near riverbanks.\n"
			)
		}
		.previewLayout(.sizeThatFits)
	}
}

