//
// Created by Joao Pedro Franco on 16/10/24
//

import SwiftUI
import JData
import JUI
import Kingfisher

struct GameDetailView: View {
	@StateObject var viewModel: GameDetailViewModel
	
	private var viewData: GameDetailViewData { viewModel.viewData }
	
	init(game: Game) {
		self._viewModel = StateObject(wrappedValue: GameDetailViewModel(game: game))
	}
	
	var body: some View {
		ZStack {
			ScrollView(.vertical) {
				VStack(spacing: .zero) {
					coverHeader
					header
					about
					ratings
					screenshots
				}
			}
			.onAppear { viewModel.load() }
			
			if viewData.isCached {
				ToastView(
					message: "Outdated game",
					backgroundColor: DesignSystem.Colors.red,
					foregroundColor: DesignSystem.Colors.white
				)
			}
		}
	}
}

private extension GameDetailView {
	@ViewBuilder
	var coverHeader: some View {
		if let cover = viewData.cover {
			KFImage.url(cover, cacheKey: viewData.id.description + "cover")
				.resizable()
				.cacheOriginalImage()
				.frame(maxWidth: .infinity, idealHeight: 120)
				.blur(radius: 10)
				.background(DesignSystem.Colors.dark)
		}
	}
	
	@ViewBuilder
	var header: some View {
		VStack(spacing: .zero) {
			VStack(alignment: .leading, spacing: DesignSystem.Spacings.xxs) {
				Text(viewData.name)
					.font(DesignSystem.Fonts.title)
					.foregroundColor(DesignSystem.Colors.white)
				
				if let releasedAt = viewData.releasedAt {
					Text(releasedAt)
						.font(DesignSystem.Fonts.default)
						.foregroundColor(DesignSystem.Colors.white)
				}
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
	var about: some View {
		if viewData.hasAbout {
			Box {
				HStack {
					VStack(alignment: .leading, spacing: DesignSystem.Spacings.xs) {
						Text("About")
							.font(DesignSystem.Fonts.section)
							.foregroundColor(DesignSystem.Colors.primary)
						
						if viewData.hasGenresOrPlatforms {
							VStack(alignment: .leading, spacing: .zero) {
								if let genres = viewData.genres, !genres.isEmpty {
									Text(genres)
										.foregroundColor(DesignSystem.Colors.primary)
										.font(DesignSystem.Fonts.small)
								}
								
								if let platforms = viewData.platforms, !platforms.isEmpty {
									Text(platforms)
										.foregroundColor(DesignSystem.Colors.primary)
										.font(DesignSystem.Fonts.small)
								}
							}
						}
						
						if let summary = viewData.summary, !summary.isEmpty {
							Text(summary)
								.foregroundColor(DesignSystem.Colors.primary)
								.font(DesignSystem.Fonts.default)
						}
					}
					
					Spacer()
				}
			}
			.padding(DesignSystem.Spacings.xs)
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
				
				if let value = viewData.ratingValue, let count = viewData.ratingCount {
					RatingView(value: value, count: count)
				} else {
					Text("N/A")
				}
			}
		}
		.padding(DesignSystem.Spacings.xs)
	}
	
	@ViewBuilder
	var screenshots: some View {
		if viewData.hasScreenshots, let screenshots = viewData.screenshots {
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
								.memoryCacheExpiration(.seconds(20))
								.placeholder { Icon(name: DesignSystem.Icons.placeholder.rawValue) }
						}
						.frame(height: 180)
				}
				.frame(maxWidth: .infinity)
			}
			.padding(DesignSystem.Spacings.xs)
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
