//
//  Created by Joao Pedro Franco on 15/07/24.
//

import Combine
import JFoundation

public protocol GamesRepositoryProtocol {
	func getGames() async -> (games: [Game], isFromCache: Bool)
	func getMoreGames() async -> [Game]?
	func getGame(id: Int) async -> (game: Game?, isFromCache: Bool)
}

public class GamesRepository: GamesRepositoryProtocol {
	private let remoteDataSource: RemoteDataSourceProtocol
	private let cacheDataSource: CacheDataSourceProtocol
	private let logger: Loggable
	
	var nextPageOfGames: Int
	private let limitOfGamesPerPage: Int
	
	/// Tests purposes
	var didSaveOnCache: (() -> Void)?

	public init(
		limitOfGamesPerPage: Int = 20,
		remoteDataSource: RemoteDataSourceProtocol = RemoteDataSource(),
		cacheDataSource: CacheDataSourceProtocol = CacheDataSource(),
		logger: Loggable = Logger.shared
	) {
		self.nextPageOfGames = 0
		self.limitOfGamesPerPage = limitOfGamesPerPage
		self.remoteDataSource = remoteDataSource
		self.cacheDataSource = cacheDataSource
		self.logger = logger
	}
	
	public func getGames() async -> (games: [Game], isFromCache: Bool) {
		nextPageOfGames = 0

		if let remoteGames = await fetchGames(), !remoteGames.isEmpty {
			saveOnCache(games: remoteGames, shouldClean: true)
			nextPageOfGames += 1

			return (remoteGames, false)
		} else if let cachedGames: [Game] = await hitCachedGames(), !cachedGames.isEmpty {
			return (cachedGames, true)
		} else {
			return ([], false)
		}
	}
	
	public func getMoreGames() async -> [Game]? {
		guard let moreGames = await fetchGames(), !moreGames.isEmpty else { return nil }
		saveOnCache(games: moreGames)
		nextPageOfGames += 1

		return moreGames
	}
	
	public func getGame(id: Int) async -> (game: Game?, isFromCache: Bool) {
		if let remoteGame = await fetchGame(id: id) {
			saveOnCache(game: remoteGame)

			return (remoteGame, false)
		} else if let cachedGame = await hitCachedGame(id: id) {
			return (cachedGame, true)
		} else {
			return (nil, false)
		}
	}
}

private extension GamesRepository {
	// MARK: - Remote
	func fetchGames() async -> [Game]? {
		do {
			let games: [Game] = try await remoteDataSource.fetch(
				request: GamesRequest.listOf(
					page: nextPageOfGames,
					limit: limitOfGamesPerPage
				)
			) ?? []

			return games
		} catch {
			logger.log(message: error.localizedDescription)
			return nil
		}
	}
	
	func fetchGame(id: Int) async -> Game? {
		do {
			let games: [Game] = try await remoteDataSource.fetch(
				request: GamesRequest.game(id: id)
			)
			guard let game = games.first else { return nil }

			return game
		} catch {
			logger.log(message: error.localizedDescription)
			return nil
		}
	}
	
	// MARK: - Cache
	func hitCachedGames() async -> [Game]? {
		await cacheDataSource.fetchAll()
	}
	
	func hitCachedGame(id: Int) async -> Game? {
		await cacheDataSource.fetch(key: id.description)
	}
	
	func saveOnCache(games: [Game], shouldClean: Bool = false) {
		Task {
			if shouldClean { await cleanGamesOnCache() }
			
			for game in games {
				await cacheDataSource.save(cacheable: game)
			}
			
			didSaveOnCache?()
		}
	}
	
	func saveOnCache(game: Game, shouldClean: Bool = false) {
		Task {
			if shouldClean { await cleanGamesOnCache() }
			await cacheDataSource.update(cacheable: game)
			didSaveOnCache?()
		}
	}
	
	func cleanGamesOnCache() async {
		await cacheDataSource.clean(cacheableType: Game.self)
	}
}
