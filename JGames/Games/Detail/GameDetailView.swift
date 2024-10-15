//
// Created by Joao Pedro Franco on 16/10/24
//

import SwiftUI
import JData
import JUI
import Kingfisher

struct GameDetailView: View {
	@StateObject var viewModel: GameDetailViewModel
	
	init(game: Game) {
		self._viewModel = StateObject(wrappedValue: GameDetailViewModel(game: game))
	}
	
	var body: some View {
		ZStack {
			ScrollView(.vertical) {
				VStack(spacing: .zero) {
					header
					underHeader
					ratings
					screenshots
				}
			}
			.onAppear { viewModel.load() }
			
			if viewModel.viewData.isCached {
				ToastView(
					message: "Outdated game",
					backgroundColor: DesignSystem.Colors.red,
					foregroundColor: DesignSystem.Colors.white
				)
			}
		}
	}
}

extension GameDetailView {
	@ViewBuilder
	var header: some View {
		HStack {
			ZStack {
				DesignSystem.Colors.dark
				
				if let cover = viewModel.viewData.cover {
					KFImage.url(cover, cacheKey: viewModel.viewData.id.description + "cover")
						.resizable()
						.cacheOriginalImage()
						.frame(maxWidth: .infinity, idealHeight: 120)
						.blur(radius: 10)
				}
				
				HStack {
					VStack(alignment: .leading) {
						Spacer()
						
						Text(viewModel.viewData.name)
							.font(DesignSystem.Fonts.title)
							.foregroundColor(DesignSystem.Colors.white)
						
						if let releasedAt = viewModel.viewData.releasedAt {
							Text(releasedAt)
								.font(DesignSystem.Fonts.default)
								.foregroundColor(DesignSystem.Colors.white)
						}
					}
					Spacer()
				}
				.padding(DesignSystem.Spacings.xs)
			}
		}
		.frame(maxWidth: .infinity)
	}
	
	@ViewBuilder
	var underHeader: some View {
		VStack(spacing: .zero) {
			VStack(alignment: .leading, spacing: DesignSystem.Spacings.xxs) {
				Text(viewModel.viewData.genres ?? "No genres")
					.foregroundColor(DesignSystem.Colors.white)
					.font(DesignSystem.Fonts.small)
				
				Text(viewModel.viewData.platforms ?? "No platforms")
					.foregroundColor(DesignSystem.Colors.white)
					.font(DesignSystem.Fonts.small)
				
				Text(viewModel.viewData.summary ?? "No summary")
					.foregroundColor(DesignSystem.Colors.white)
					.font(DesignSystem.Fonts.default)
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			.padding(DesignSystem.Spacings.xs)
			.background(DesignSystem.Colors.primary)
			
			Rectangle()
				.fill(DesignSystem.Colors.secondary)
				.frame(height: 3)
		}
	}
	
	@ViewBuilder
	var ratings: some View {
		Box {
			HStack {
				Text("Reviews")
					.font(DesignSystem.Fonts.section)
					.foregroundColor(DesignSystem.Colors.primary)
				
				Spacer()
				
				if let value = viewModel.viewData.ratingValue, let count = viewModel.viewData.ratingCount {
					RatingView(value: value, count: count)
				} else {
					Text("N/A")
				}
			}
		}
		.padding(DesignSystem.Spacings.xs)
		.frame(maxWidth: .infinity)
	}
	
	@ViewBuilder
	var screenshots: some View {
		if let screenshots = viewModel.viewData.screenshots {
			Box {
				VStack(alignment: .leading) {
					Text("Screenshots")
						.font(DesignSystem.Fonts.section)
						.foregroundColor(DesignSystem.Colors.primary)
					
					Spacer()
					
					Carousel(
						data: screenshots,
						spacing: DesignSystem.Spacings.xxs,
						cellRatio: 0.85) { _, object in
							KFImage.url(object)
								.resizable()
								.cacheMemoryOnly()
								.memoryCacheExpiration(.seconds(120))
								.placeholder { Icon(name: DesignSystem.Icons.placeholder.rawValue) }
						}
						.frame(height: 150)
				}
			}
			.padding(DesignSystem.Spacings.xs)
			.frame(maxWidth: .infinity)
		}
	}
}


struct GameDetailView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			GameDetailView(game: PreviewGame.regular)
			GameDetailView(game: PreviewGame.imcomplete)
			GameDetailView(game: PreviewGame.noRatings)
		}
	}
}
