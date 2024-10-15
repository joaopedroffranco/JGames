//
//  Created by Joao Pedro Franco on 15/10/24.
//

import XCTest
import JData
@testable import JGames

class GamesCellDataTests: XCTestCase {
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
		let data = GameCellData(from: game)
		
		// then
		XCTAssertEqual(
			data,
			.init(
				id: game.id,
				image: game.screenshots?.first?.thumbUrl,
				name: game.name,
				year: game.releasedAt?.date?.asYear ?? ""
			)
		)
	}
}
