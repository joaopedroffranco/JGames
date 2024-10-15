//
// Created by Joao Pedro Franco on 19/10/24
//
	
import XCTest
import Combine
@testable import JGames
@testable import JData

class GamesListViewModelTests: XCTestCase {
	private var cancellables: Set<AnyCancellable> = []
	
	// MARK: - Load
	func testLoad() {
		// given
		let listOfRemote = [
			GamesStub.regular(id: 1),
			GamesStub.regular(id: 2),
			GamesStub.regular(id: 3)
		]

		let repository = FakeGamesRepository(remoteGames: listOfRemote)
		let viewModel = GamesListViewModel(repository: repository)
		
		// when
		let expectation = XCTestExpectation(description: "Loading")
		var expectedState = GamesListViewState.loading
		viewModel.$state
			.dropFirst()
			.sink { state in
				expectedState = state
				expectation.fulfill()
			}
			.store(in: &cancellables)
		
		viewModel.load()
		
		wait(for: [expectation], timeout: 1)

		// then
		XCTAssertEqual(expectedState, .data(games: listOfRemote, isCached: false))
	}
	
	func testLoadEmpty() {
		// given
		let repository = FakeGamesRepository(remoteGames: [])
		let viewModel = GamesListViewModel(repository: repository)
		
		// when
		let expectation = XCTestExpectation(description: "Loading")
		var expectedState = GamesListViewState.loading
		viewModel.$state
			.dropFirst()
			.sink { state in
				expectedState = state
				expectation.fulfill()
			}
			.store(in: &cancellables)
		
		viewModel.load()
		
		wait(for: [expectation], timeout: 1)

		// then
		XCTAssertEqual(expectedState, .error)
	}
	
	func testLoadEmptyWithCache() {
		// given
		let listOfCached = [
			GamesStub.regular(id: 1),
			GamesStub.regular(id: 2),
			GamesStub.regular(id: 3)
		]
		let repository = FakeGamesRepository(remoteGames: nil, cachedGames: listOfCached)
		let viewModel = GamesListViewModel(repository: repository)
		
		// when
		let expectation = XCTestExpectation(description: "Loading")
		var expectedState = GamesListViewState.loading
		viewModel.$state
			.dropFirst()
			.sink { state in
				expectedState = state
				expectation.fulfill()
			}
			.store(in: &cancellables)
		
		viewModel.load()
		
		wait(for: [expectation], timeout: 1)

		// then
		XCTAssertEqual(expectedState, .data(games: listOfCached, isCached: true))
	}
	
	// MARK: - Load More
	func testLoadMoreBeginning() {
		// given
		let listOfRemote = [
			GamesStub.regular(id: 1),
			GamesStub.regular(id: 2),
			GamesStub.regular(id: 3),
			GamesStub.regular(id: 4),
			GamesStub.regular(id: 5)
		]

		let repository = FakeGamesRepository(remoteGames: listOfRemote)
		let viewModel = GamesListViewModel(repository: repository)
		viewModel.state = GamesListViewState.data(games: listOfRemote, isCached: false)
		
		// when
		let expectation = XCTestExpectation(description: "Task completion")
		var expectedState = viewModel.state
		viewModel.$state
			.dropFirst()
			.sink { state in
				expectedState = state
				XCTFail("State should not change")
			}
			.store(in: &cancellables)
		
		viewModel.loadMoreIfNeeded(index: 0)
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
			expectation.fulfill()
		}
		
		wait(for: [expectation], timeout: 1.25)

		// then
		XCTAssertEqual(expectedState, .data(games: listOfRemote, isCached: false))
	}
	
	func testLoadMoreEnd() {
		// given
		let listOfRemote = [
			GamesStub.regular(id: 1),
			GamesStub.regular(id: 2),
			GamesStub.regular(id: 3),
			GamesStub.regular(id: 4),
			GamesStub.regular(id: 5)
		]

		let repository = FakeGamesRepository(remoteGames: listOfRemote)
		let viewModel = GamesListViewModel(repository: repository)
		viewModel.state = GamesListViewState.data(games: listOfRemote, isCached: false)
		
		// when
		let expectation = XCTestExpectation(description: "Loading more")
		var expectedState = viewModel.state
		viewModel.$state
			.dropFirst()
			.sink { state in
				expectedState = state
				expectation.fulfill()
			}
			.store(in: &cancellables)
		
		viewModel.loadMoreIfNeeded(index: 3)
		
		wait(for: [expectation], timeout: 1)

		// then
		XCTAssertEqual(expectedState, .data(games: listOfRemote + listOfRemote, isCached: false))
	}
	
	func testLoadMoreEndButEmpty() {
		// given
		let listOfRemote = [
			GamesStub.regular(id: 1),
			GamesStub.regular(id: 2),
			GamesStub.regular(id: 3),
			GamesStub.regular(id: 4),
			GamesStub.regular(id: 5)
		]

		let repository = FakeGamesRepository(remoteGames: nil)
		let viewModel = GamesListViewModel(repository: repository)
		viewModel.state = GamesListViewState.data(games: listOfRemote, isCached: false)
		
		// when
		let expectation = XCTestExpectation(description: "Task completion")
		var expectedState = viewModel.state
		viewModel.$state
			.dropFirst()
			.sink { state in
				expectedState = state
				XCTFail("State should not change")
			}
			.store(in: &cancellables)
		
		viewModel.loadMoreIfNeeded(index: 3)
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
			expectation.fulfill()
		}
		
		wait(for: [expectation], timeout: 1.25)

		// then
		XCTAssertEqual(expectedState, .data(games: listOfRemote, isCached: false))
	}
	
	func testLoadMoreEndButCached() {
		// given
		let listOfCached = [
			GamesStub.regular(id: 1),
			GamesStub.regular(id: 2),
			GamesStub.regular(id: 3),
			GamesStub.regular(id: 4),
			GamesStub.regular(id: 5)
		]

		let repository = FakeGamesRepository(remoteGames: listOfCached)
		let viewModel = GamesListViewModel(repository: repository)
		viewModel.state = GamesListViewState.data(games: listOfCached, isCached: true)
		
		// when
		let expectation = XCTestExpectation(description: "Task completion")
		var expectedState = viewModel.state
		viewModel.$state
			.dropFirst()
			.sink { state in
				expectedState = state
				XCTFail("State should not change")
			}
			.store(in: &cancellables)
		
		viewModel.loadMoreIfNeeded(index: 3)
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
			expectation.fulfill()
		}
		
		wait(for: [expectation], timeout: 1.25)

		// then
		XCTAssertEqual(expectedState, .data(games: listOfCached, isCached: true))
	}
	
	// MARK: - Select
	func testSelect() {
		// given
		let game = GamesStub.regular(id: 1)
		let repository = FakeGamesRepository(remoteGames: [game])
		let viewModel = GamesListViewModel(repository: repository)
		
		// when
		let expectation = XCTestExpectation(description: "Loading")
		var expectedSelected: Game?
		viewModel.$gameSelected
			.dropFirst()
			.sink { selected in
				expectedSelected = selected
				expectation.fulfill()
			}
			.store(in: &cancellables)
		
		viewModel.select(game: game)
		
		wait(for: [expectation], timeout: 1)

		// then
		XCTAssertEqual(expectedSelected, game)
	}
}
