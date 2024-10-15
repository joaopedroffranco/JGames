//
// Created by Joao Pedro Franco on 19/10/24
//
	
import Foundation
@testable import JData

enum GamesStub {
	private static let platforms: [Platform] = [
		.init(name: "PC"),
		.init(name: "Play Station 5"),
		.init(name: "Xbox One"),
	]
	
	private static let genres: [Genre] = [
		.init(name: "Strategy"),
		.init(name: "Shooting"),
		.init(name: "Multiplayer"),
	]
	
	static func regular(id: Int) -> Game {
		.init(
			id: id,
			name: "Call of Duty",
			releasedAt: 1530519587,
			screenshots: [.init(id: "em1y2ugcwy2myuhvb9db")],
			summary: "Call of Duty is a military video game series and media franchise published by Activision, starting in 2003.",
			rating: .init(value: 10, count: 10),
			platforms: platforms,
			genres: genres
		)
	}
}

