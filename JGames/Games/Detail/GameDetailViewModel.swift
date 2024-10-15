//
// Created by Joao Pedro Franco on 16/10/24
//

import Combine
import JData

class GameDetailViewModel: ObservableObject {
	@Published var viewData: GameDetailViewData
	
	private let game: Game
	private let repository: GamesRepositoryProtocol
	
	init(game: Game, repository: GamesRepositoryProtocol = GamesRepository()) {
		self.game = game
		self.viewData = GameDetailViewData(from: game)
		self.repository = repository
	}
	
	func load() {
		Task {
			let (game, isCached) = await repository.getGame(id: game.id)

			if let game = game {
				Task { @MainActor in
					self.viewData = GameDetailViewData(from: game, isCached: isCached)
				}
			}
		}
	}
}
