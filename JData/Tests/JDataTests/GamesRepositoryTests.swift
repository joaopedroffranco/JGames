import XCTest
@testable import JData

final class GamesRepositoryTests: XCTestCase {
	
	// MARK: - Get Games
	func testGetGamesRegularResponse() async {
		// given
		let remoteDataSource = FakeRemoteDataSource(jsonFile: JSONFile.regular)
		let cacheDataSource = FakeCacheDataSource()
		let repository = GamesRepository(
			remoteDataSource: remoteDataSource,
			cacheDataSource: cacheDataSource
		)
		
		let expectation = expectation(description: "Saving on cache")
		repository.didSaveOnCache = {
			expectation.fulfill()
		}
		
		// when
		XCTAssertEqual(repository.nextPageOfGames, 0)
		let (games, isCached) = await repository.getGames()
		
		// then
		XCTAssertEqual(repository.nextPageOfGames, 1)
		XCTAssertFalse(isCached)
		XCTAssertEqual(games.count, 20)

		await waitForExpectations(timeout: 1)
		XCTAssertEqual(cacheDataSource.cache.count, 20)
	}
	
	func testGetGamesRegularResponseWithCache() async {
		// given
		let remoteDataSource = FakeRemoteDataSource(jsonFile: JSONFile.regular)
		let cacheDataSource = FakeCacheDataSource([
			GamesStub.regular(id: 1),
			GamesStub.regular(id: 2),
			GamesStub.regular(id: 3)
		])
		let repository = GamesRepository(
			remoteDataSource: remoteDataSource,
			cacheDataSource: cacheDataSource
		)
		
		let expectation = expectation(description: "Saving on cache")
		repository.didSaveOnCache = {
			expectation.fulfill()
		}
		
		// when
		XCTAssertEqual(cacheDataSource.cache.count, 3)
		XCTAssertEqual(repository.nextPageOfGames, 0)
		let (games, isCached) = await repository.getGames()
		
		// then
		XCTAssertEqual(repository.nextPageOfGames, 1)
		XCTAssertFalse(isCached)
		XCTAssertEqual(games.count, 20)

		await waitForExpectations(timeout: 1)
		XCTAssertEqual(cacheDataSource.cache.count, 20)
	}

	
	func testGetGamesErrorEmptyResponseWithEmptyCache() async {
		// given
		let remoteDataSource = FakeRemoteDataSource(jsonFile: JSONFile.empty)
		let cacheDataSource = FakeCacheDataSource()
		let repository = GamesRepository(
			remoteDataSource: remoteDataSource,
			cacheDataSource: cacheDataSource
		)
		
		// when
		XCTAssertEqual(repository.nextPageOfGames, 0)
		let (games, isCached) = await repository.getGames()
		
		// then
		XCTAssertEqual(repository.nextPageOfGames, 0)
		XCTAssertFalse(isCached)
		XCTAssertTrue(games.isEmpty)
		XCTAssertEqual(cacheDataSource.cache.count, 0)
	}
	
	func testGetGamesErrorEmptyResponseWithCache() async {
		// given
		let remoteDataSource = FakeRemoteDataSource(jsonFile: JSONFile.empty)
		let cacheDataSource = FakeCacheDataSource([
			GamesStub.regular(id: 1),
			GamesStub.regular(id: 2),
			GamesStub.regular(id: 3)
		])
		let repository = GamesRepository(
			remoteDataSource: remoteDataSource,
			cacheDataSource: cacheDataSource
		)
		
		// when
		XCTAssertEqual(repository.nextPageOfGames, 0)
		let (games, isCached) = await repository.getGames()
		
		// then
		XCTAssertEqual(repository.nextPageOfGames, 0)
		XCTAssertTrue(isCached)
		XCTAssertEqual(games.count, 3)
		XCTAssertEqual(cacheDataSource.cache.count, 3)
	}
	
	func testGetGamesErrorInvalidResponseWithCache() async {
		// given
		let remoteDataSource = FakeRemoteDataSource(jsonFile: JSONFile.invalid)
		let cacheDataSource = FakeCacheDataSource([
			GamesStub.regular(id: 1),
			GamesStub.regular(id: 2),
			GamesStub.regular(id: 3)
		])
		let repository = GamesRepository(
			remoteDataSource: remoteDataSource,
			cacheDataSource: cacheDataSource
		)
		
		// when
		XCTAssertEqual(repository.nextPageOfGames, 0)
		let (games, isCached) = await repository.getGames()
		
		// then
		XCTAssertEqual(repository.nextPageOfGames, 0)
		XCTAssertTrue(isCached)
		XCTAssertEqual(games.count, 3)
		XCTAssertEqual(cacheDataSource.cache.count, 3)
	}
	
	// MARK: - Get More Games
	func testGetMoreGamesRegular() async {
		// given
		let remoteDataSource = FakeRemoteDataSource(jsonFile: JSONFile.regularSecond)
		let cacheDataSource = FakeCacheDataSource()
		let repository = GamesRepository(
			remoteDataSource: remoteDataSource,
			cacheDataSource: cacheDataSource
		)
		
		let expectation = expectation(description: "Saving on cache")
		repository.didSaveOnCache = {
			expectation.fulfill()
		}
		
		// when
		XCTAssertEqual(repository.nextPageOfGames, 0)
		guard let games = await repository.getMoreGames() else {
			return XCTFail("Games isn't supposed to be nil")
		}
		
		// then
		XCTAssertEqual(repository.nextPageOfGames, 1)
		XCTAssertEqual(games.count, 20)
		
		await waitForExpectations(timeout: 1)
		XCTAssertEqual(cacheDataSource.cache.count, 20)
	}
	
	func testGetMoreGamesRegularWithCache() async {
		// given
		let remoteDataSource = FakeRemoteDataSource(jsonFile: JSONFile.regularSecond)
		let cacheDataSource = FakeCacheDataSource([
			GamesStub.regular(id: 1),
			GamesStub.regular(id: 2),
			GamesStub.regular(id: 3)
		])
		let repository = GamesRepository(
			remoteDataSource: remoteDataSource,
			cacheDataSource: cacheDataSource
		)
		
		let expectation = expectation(description: "Saving on cache")
		repository.didSaveOnCache = {
			expectation.fulfill()
		}
		
		// when
		XCTAssertEqual(repository.nextPageOfGames, 0)
		guard let games = await repository.getMoreGames() else {
			return XCTFail("Games isn't supposed to be nil")
		}
		
		// then
		XCTAssertEqual(repository.nextPageOfGames, 1)
		XCTAssertEqual(games.count, 20)
		
		await waitForExpectations(timeout: 1)
		XCTAssertEqual(cacheDataSource.cache.count, 23)
	}
	
	func testGetMoreGamesEmpty() async {
		// given
		let remoteDataSource = FakeRemoteDataSource(jsonFile: JSONFile.empty)
		let cacheDataSource = FakeCacheDataSource()
		let repository = GamesRepository(
			remoteDataSource: remoteDataSource,
			cacheDataSource: cacheDataSource
		)
		
		// when
		XCTAssertEqual(repository.nextPageOfGames, 0)
		let games = await repository.getMoreGames()
		
		// then
		XCTAssertEqual(repository.nextPageOfGames, 0)
		XCTAssertNil(games)
		
		XCTAssertEqual(cacheDataSource.cache.count, 0)
	}
	
	func testGetMoreGamesEmptyWithCache() async {
		// given
		let remoteDataSource = FakeRemoteDataSource(jsonFile: JSONFile.empty)
		let cacheDataSource = FakeCacheDataSource([
			GamesStub.regular(id: 1),
			GamesStub.regular(id: 2),
			GamesStub.regular(id: 3)
		])
		let repository = GamesRepository(
			remoteDataSource: remoteDataSource,
			cacheDataSource: cacheDataSource
		)
		
		// when
		XCTAssertEqual(repository.nextPageOfGames, 0)
		let games = await repository.getMoreGames()
		
		// then
		XCTAssertEqual(repository.nextPageOfGames, 0)
		XCTAssertNil(games)
		XCTAssertEqual(cacheDataSource.cache.count, 3)
	}
	
	func testGetMoreGamesInvalid() async {
		// given
		let remoteDataSource = FakeRemoteDataSource(jsonFile: JSONFile.invalid)
		let cacheDataSource = FakeCacheDataSource()
		let repository = GamesRepository(
			remoteDataSource: remoteDataSource,
			cacheDataSource: cacheDataSource
		)
		
		// when
		XCTAssertEqual(repository.nextPageOfGames, 0)
		let games = await repository.getMoreGames()
		
		// then
		XCTAssertEqual(repository.nextPageOfGames, 0)
		XCTAssertNil(games)
		
		XCTAssertEqual(cacheDataSource.cache.count, 0)
	}
	
	func testGetMoreGamesInvalidWithCache() async {
		// given
		let remoteDataSource = FakeRemoteDataSource(jsonFile: JSONFile.invalid)
		let cacheDataSource = FakeCacheDataSource([
			GamesStub.regular(id: 1),
			GamesStub.regular(id: 2),
			GamesStub.regular(id: 3)
		])
		let repository = GamesRepository(
			remoteDataSource: remoteDataSource,
			cacheDataSource: cacheDataSource
		)
		
		// when
		XCTAssertEqual(repository.nextPageOfGames, 0)
		let games = await repository.getMoreGames()
		
		// then
		XCTAssertEqual(repository.nextPageOfGames, 0)
		XCTAssertNil(games)
		XCTAssertEqual(cacheDataSource.cache.count, 3)
	}
	
	// MARK: - Get Game
	func testGetGameRegularResponse() async {
		// given
		let remoteDataSource = FakeRemoteDataSource(jsonFile: JSONFile.regularGame)
		let cacheDataSource = FakeCacheDataSource()
		let repository = GamesRepository(
			remoteDataSource: remoteDataSource,
			cacheDataSource: cacheDataSource
		)
		
		let expectation = expectation(description: "Saving on cache")
		repository.didSaveOnCache = {
			expectation.fulfill()
		}
		
		// when
		let expectedGame = Game(
			id: 1,
			name: "Call of Duty",
			releasedAt: 1532466570,
			screenshots: [.init(id: "1"), .init(id: "2"), .init(id: "3")],
			summary: "This is a quick summary",
			rating: Rating(value: 70.2, count: 100),
			platforms: [.init(name: "PC"), .init(name: "PS5")],
			genres: [.init(name: "Strategy"), .init(name: "Shooting")]
		)
		let (game, isCached) = await repository.getGame(id: 1)
		
		// then
		XCTAssertFalse(isCached)
		XCTAssertEqual(game, expectedGame)

		await waitForExpectations(timeout: 1)
		XCTAssertEqual(cacheDataSource.cache["1"] as? Game, expectedGame)
	}
	
	func testGetGameRegularResponseWithCache() async {
		// given
		let remoteDataSource = FakeRemoteDataSource(jsonFile: JSONFile.regularGame)
		let cacheDataSource = FakeCacheDataSource([
			GamesStub.regular(id: 1),
			GamesStub.regular(id: 2),
			GamesStub.regular(id: 3)
		])
		let repository = GamesRepository(
			remoteDataSource: remoteDataSource,
			cacheDataSource: cacheDataSource
		)
		
		let expectation = expectation(description: "Saving on cache")
		repository.didSaveOnCache = {
			expectation.fulfill()
		}
		
		// when
		let expectedGame = Game(
			id: 1,
			name: "Call of Duty",
			releasedAt: 1532466570,
			screenshots: [.init(id: "1"), .init(id: "2"), .init(id: "3")],
			summary: "This is a quick summary",
			rating: Rating(value: 70.2, count: 100),
			platforms: [.init(name: "PC"), .init(name: "PS5")],
			genres: [.init(name: "Strategy"), .init(name: "Shooting")]
		)
		XCTAssertEqual(cacheDataSource.cache["1"] as? Game, GamesStub.regular(id: 1))
		let (game, isCached) = await repository.getGame(id: 1)
		
		// then
		XCTAssertFalse(isCached)
		XCTAssertEqual(game, expectedGame)

		await waitForExpectations(timeout: 1)
		XCTAssertEqual(cacheDataSource.cache.count, 3)
		XCTAssertEqual(cacheDataSource.cache["1"] as? Game, expectedGame)
	}
	
	func testGetGameEmptyResponse() async {
		// given
		let remoteDataSource = FakeRemoteDataSource(jsonFile: JSONFile.empty)
		let cacheDataSource = FakeCacheDataSource()
		let repository = GamesRepository(
			remoteDataSource: remoteDataSource,
			cacheDataSource: cacheDataSource
		)
		
		// when
		let (game, isCached) = await repository.getGame(id: 1)
		
		// then
		XCTAssertFalse(isCached)
		XCTAssertNil(game)
		XCTAssertEqual(cacheDataSource.cache.count, 0)
	}
	
	func testGetGameEmptyResponseWithCache() async {
		// given
		let remoteDataSource = FakeRemoteDataSource(jsonFile: JSONFile.empty)
		let cacheDataSource = FakeCacheDataSource([
			GamesStub.regular(id: 1),
			GamesStub.regular(id: 2),
			GamesStub.regular(id: 3)
		])
		let repository = GamesRepository(
			remoteDataSource: remoteDataSource,
			cacheDataSource: cacheDataSource
		)
		
		// when
		let expectedGame = GamesStub.regular(id: 1)
		let (game, isCached) = await repository.getGame(id: 1)
		
		// then
		XCTAssertTrue(isCached)
		XCTAssertEqual(game, expectedGame)

		XCTAssertEqual(cacheDataSource.cache.count, 3)
		XCTAssertEqual(cacheDataSource.cache["1"] as? Game, expectedGame)
	}
}
