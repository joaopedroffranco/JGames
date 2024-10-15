//
// Created by Joao Pedro Franco on 24/09/24
//

import SwiftUI
import JFoundation
import JUI
import Kingfisher

struct GameCell: View {
	let data: GameCellData
	let height: CGFloat
	
	var body: some View {
		HStack(spacing: DesignSystem.Spacings.xs) {
			KFImage.url(data.image, cacheKey: data.id.description + "thumb")
				.resizable()
				.loadDiskFileSynchronously()
				.cacheOriginalImage()
				.placeholder { Icon(name: DesignSystem.Icons.placeholder.rawValue) }
				.frame(width: height, height: height, alignment: .center)
				.cornerRadius(DesignSystem.Radius.default)
			
			HStack(spacing: DesignSystem.Spacings.xxxxs) {
				Text(data.name)
					.foregroundColor(DesignSystem.Colors.primary)
					.font(DesignSystem.Fonts.big)
					.lineLimit(1)
				
				if let year = data.year {
					Text("(\(year))")
						.foregroundColor(DesignSystem.Colors.primary.opacity(0.6))
						.font(DesignSystem.Fonts.default)
				}
			}
			
			Spacer()
		}
		.padding(.trailing, DesignSystem.Spacings.xs)
		.frame(height: height)
	}
}

struct GameCell_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			GameCell(
				data: .init(
					id: 1,
					image: nil,
					name: "Game number 2",
					year: "2025"
				),
				height: 70
			)
			GameCell(
				data: .init(
					id: 1,
					image: nil,
					name: "Game number 2 with a longer name",
					year: "2014"
				),
				height: 70
			)
		}
		.previewLayout(.sizeThatFits)
	}
}
