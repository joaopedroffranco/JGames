//
// Created by Joao Pedro Franco on 16/10/24
//

import Combine
import JData

enum GamesListViewState: Equatable {
	case loading
	case data(games: [Game], isCached: Bool)
	case error
}

class GamesListViewModel: ObservableObject {
	@Published var state: GamesListViewState = .loading
	@Published var gameSelected: Game?
	
	private let repository: GamesRepositoryProtocol
	
	init(repository: GamesRepositoryProtocol = GamesRepository()) {
		self.repository = repository
	}
	
	func load() {
		Task {
			let (games, isCached) = await repository.getGames()
			
			if games.isEmpty {
				Task { @MainActor in self.state = .error }
			} else {
				Task { @MainActor in self.state = .data(games: games, isCached: isCached) }
			}
		}
	}
	
	func select(game: Game) {
		gameSelected = game
	}
	
	func loadMoreIfNeeded(index: Int) {
		switch state {
		case .loading, .error, .data(_, true): return
		case let .data(current, false):
			if shouldLoadMore(index, count: current.count) {
				Task {
					if let moreGames = await repository.getMoreGames() {
						let data = current + moreGames
						Task { @MainActor in
							self.state = .data(games: data, isCached: false)
						}
					}
				}
			}
		}
	}
}

private extension GamesListViewModel {
	func shouldLoadMore(_ index: Int, count: Int) -> Bool {
		index == count - 2
	}
}
