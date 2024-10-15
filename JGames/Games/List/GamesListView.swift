//
// Created by Joao Pedro Franco on 16/10/24
//

import SwiftUI
import JUI

struct GamesListView: View {
	@StateObject var viewModel: GamesListViewModel = .init()
	
	var body: some View {
		content
			.onAppear { viewModel.load() }
			.refreshable { viewModel.load() }
			.sheet(item: $viewModel.gameSelected) { GameDetailView(game: $0) }
	}
}

extension GamesListView {
	@ViewBuilder
	var content: some View {
		switch viewModel.state {
		case .loading:
			ProgressView()
		case .error:
			VStack {
				Text("Sorry :(\n\nCouldn't load the list of games\n")
					.multilineTextAlignment(.center)
				
				Button("Reload") { viewModel.load() }
					.tint(DesignSystem.Colors.secondary)
			}
		case let .data(games, isCached):
			ZStack {
				JList(data: games) { index, game in
					GameCell(data: GameCellData(from: game), height: 75)
						.onAppear { viewModel.loadMoreIfNeeded(index: index) }
						.padding(DesignSystem.Spacings.xs)
						.onTapGesture { viewModel.select(game: game) }
				}
				
				if isCached {
					ToastView(
						message: "Outdated games",
						backgroundColor: DesignSystem.Colors.red,
						foregroundColor: DesignSystem.Colors.white
					)
				}
			}
		}
	}
}
