//
// Created by Joao Pedro Franco on 19/10/24
//
	
import Foundation
@testable import JData

class FakeGamesRepository: GamesRepositoryProtocol {
	private var remoteGames: [Int: Game]?
	private var cachedGames: [Int: Game]?
	
	init(
		remoteGames: [Game]?,
		cachedGames: [Game]? = nil
	) {
		self.remoteGames = remoteGames?.reduce(into: [:]) { $0[$1.id] = $1 }
		self.cachedGames = cachedGames?.reduce(into: [:]) { $0[$1.id] = $1 }
	}
	
	func getGames() async -> (games: [Game], isFromCache: Bool) {
		if let remoteGames = remoteGames {
			return (Array(remoteGames.values).sorted, false)
		} else if let cachedGames = cachedGames {
			return (Array(cachedGames.values).sorted, true)
		} else {
			return ([], false)
		}
	}
	
	func getMoreGames() async -> [Game]? {
		guard let remoteGames = remoteGames else { return nil }
		return Array(remoteGames.values).sorted
	}
	
	func getGame(id: Int) async -> (game: Game?, isFromCache: Bool) {
		if let remoteGames = remoteGames, let remote = remoteGames[id] {
			return (remote, false)
		} else if let cachedGames = cachedGames, let cached = cachedGames[id] {
			return (cached, true)
		} else {
			return (nil, false)
		}
	}
}

private extension Array where Element == Game {
	var sorted: [Element] { sorted { $0.id < $1.id } }
}
