//
// Created by Joao Pedro Franco on 19/10/24
//
	
import XCTest
import JData
@testable import JGames

class GamesDetailViewDataTests: XCTestCase {
	func test() throws {
		// given
		let game = Game(
			id: 1,
			name: "Call of Duty",
			releasedAt: 1532466570,
			screenshots: [.init(id: "1"), .init(id: "2"), .init(id: "3")],
			summary: "This is a quick summary",
			rating: Rating(value: 70.2, count: 100),
			platforms: [.init(name: "PC"), .init(name: "PS5")],
			genres: [.init(name: "Strategy"), .init(name: "Shooting")]
		)
		
		// when
		let data = GameDetailViewData(from: game, isCached: false)
		
		// then
		XCTAssertEqual(
			data,
			.init(
				id: game.id,
				name: game.name,
				cover: game.screenshots?.first?.coverUrl,
				releasedAt: game.releasedAt?.date?.asString,
				summary: game.summary,
				platforms: game.platforms?.map { $0.name }.asSlashString,
				genres: game.genres?.map { $0.name }.asCommaString,
				ratingValue: game.rating?.value,
				ratingCount: game.rating?.count,
				screenshots: game.screenshots?.compactMap { $0.regularUrl },
				isCached: false
			)
		)
	}
	
	func testCached() throws {
		// given
		let game = Game(
			id: 1,
			name: "Call of Duty",
			releasedAt: 1532466570,
			screenshots: [.init(id: "1"), .init(id: "2"), .init(id: "3")],
			summary: "This is a quick summary",
			rating: Rating(value: 70.2, count: 100),
			platforms: [.init(name: "PC"), .init(name: "PS5")],
			genres: [.init(name: "Strategy"), .init(name: "Shooting")]
		)
		
		// when
		let data = GameDetailViewData(from: game, isCached: true)
		
		// then
		XCTAssertEqual(
			data,
			.init(
				id: game.id,
				name: game.name,
				cover: game.screenshots?.first?.coverUrl,
				releasedAt: game.releasedAt?.date?.asString,
				summary: game.summary,
				platforms: game.platforms?.map { $0.name }.asSlashString,
				genres: game.genres?.map { $0.name }.asCommaString,
				ratingValue: game.rating?.value,
				ratingCount: game.rating?.count,
				screenshots: game.screenshots?.compactMap { $0.regularUrl },
				isCached: true
			)
		)
	}
}

