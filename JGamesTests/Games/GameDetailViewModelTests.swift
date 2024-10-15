//
// Created by Joao Pedro Franco on 19/10/24
//

import XCTest
import Combine
@testable import JGames

class GamesDetailViewModelTests: XCTestCase {
	private var cancellables: Set<AnyCancellable> = []
	
	func testLoad() {
		// given
		let initialGame = GamesStub.regular(id: 1)
		let finalGame = GamesStub.anotherRegular(id: 1)
		let repository = FakeGamesRepository(remoteGames: [finalGame])
		let viewModel = GameDetailViewModel(game: initialGame, repository: repository)
		
		// when
		let expectation = XCTestExpectation(description: "Loading")
		var expectedViewData = GameDetailViewData(from: initialGame, isCached: false)
		viewModel.$viewData
			.dropFirst()
			.sink { viewData in
				expectedViewData = viewData
				expectation.fulfill()
			}
			.store(in: &cancellables)
		
		viewModel.load()
		
		wait(for: [expectation], timeout: 1)
		
		// then
		XCTAssertEqual(expectedViewData, GameDetailViewData(from: finalGame, isCached: false))
	}
	
	func testLoadEmpty() {
		// given
		let initialGame = GamesStub.regular(id: 1)
		let repository = FakeGamesRepository(remoteGames: [])
		let viewModel = GameDetailViewModel(game: initialGame, repository: repository)
		
		// when
		let expectation = XCTestExpectation(description: "Task completion")
		var expectedViewData = GameDetailViewData(from: initialGame, isCached: false)
		viewModel.$viewData
			.dropFirst()
			.sink { viewData in
				expectedViewData = viewData
				XCTFail("View Data should not change")
			}
			.store(in: &cancellables)
		
		viewModel.load()
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
			expectation.fulfill()
		}
		
		wait(for: [expectation], timeout: 1.25)
		
		// then
		XCTAssertEqual(expectedViewData, GameDetailViewData(from: initialGame, isCached: false))
	}
	
	func testLoadWithCache() {
		// given
		let initialGame = GamesStub.regular(id: 1)
		let finalGame = GamesStub.anotherRegular(id: 1)
		let repository = FakeGamesRepository(remoteGames: [], cachedGames: [finalGame])
		let viewModel = GameDetailViewModel(game: initialGame, repository: repository)
		
		// when
		let expectation = XCTestExpectation(description: "Loading")
		var expectedViewData = GameDetailViewData(from: initialGame, isCached: false)
		viewModel.$viewData
			.dropFirst()
			.sink { viewData in
				expectedViewData = viewData
				expectation.fulfill()
			}
			.store(in: &cancellables)
		
		viewModel.load()
		
		wait(for: [expectation], timeout: 1)
		
		// then
		XCTAssertEqual(expectedViewData, GameDetailViewData(from: finalGame, isCached: true))
	}
}
