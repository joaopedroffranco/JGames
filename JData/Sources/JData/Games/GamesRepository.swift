//
//  Created by Joao Pedro Franco on 15/07/24.
//

import Combine
import JFoundation

/// Protocol for creating a service to fetch `Forecast` data based on latitude and longitude.
public protocol GamesRepositoryProtocol {
	func getGames() async -> (games: [Game], isFromCache: Bool)
	func getMoreGames() async -> [Game]?
	func getGame(id: Int) async -> (game: Game?, isFromCache: Bool)
}

/// Conforms to `ForecastServiceProtocol`.
///
/// This implementation uses a `RemoteDataSource` to fetch forecast data.
/// In the future, a cached data source may be implemented to support offline functionality if needed.
public class GamesRepository: GamesRepositoryProtocol {
	private let remoteDataSource: RemoteDataSourceProtocol
	private let cacheDataSource: CacheDataSourceProtocol
	private let logger: Loggable
	
	private var page: Int
	private let limit: Int
	
	/// The remote is the default data source.
	public init(
		limit: Int = 20,
		remoteDataSource: RemoteDataSourceProtocol = RemoteDataSource(),
		cacheDataSource: CacheDataSourceProtocol = CacheDataSource(),
		logger: Loggable = Logger.shared
	) {
		self.page = 0
		self.limit = limit
		self.remoteDataSource = remoteDataSource
		self.cacheDataSource = cacheDataSource
		self.logger = logger
	}
	
	public func getGames() async -> (games: [Game], isFromCache: Bool) {
		page = 0
		if let remoteGames = await fetchGames(), !remoteGames.isEmpty {
			return (remoteGames, false)
		} else if let cachedGames: [Game] = await hitCachedGames() {
			return (cachedGames, true)
		} else {
			return ([], false)
		}
	}
	
	public func getMoreGames() async -> [Game]? {
		page += 1
		return await fetchGames()
	}
	
	public func getGame(id: Int) async -> (game: Game?, isFromCache: Bool) {
		if let remoteGame = await fetchGame(id: id) {
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
					page: page,
					limit: limit
				)
			) ?? []
			
			saveOnCache(games: games)
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
			
			saveOnCache(game: game)
			return game
		} catch {
			logger.log(message: error.localizedDescription)
			return nil
		}
	}
	
	// MARK: - Cache
	func hitCachedGames() async -> [Game]? {
		await cacheDataSource.fetch() ?? []
	}
	
	func hitCachedGame(id: Int) async -> Game? {
		await cacheDataSource.fetch(id: id)
	}
	
	func saveOnCache(games: [Game]) {
		Task {
			await cleanGamesOnCache()
			
			for game in games {
				await cacheDataSource.save(cacheable: game)
			}
		}
	}
	
	func saveOnCache(game: Game) {
		Task {
			await cacheDataSource.update(id: game.id, cacheable: game)
		}
	}
	
	func cleanGamesOnCache() async {
		await cacheDataSource.clean(entityType: Game.self)
	}
}
