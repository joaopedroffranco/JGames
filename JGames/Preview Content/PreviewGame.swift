//
// Created by Joao Pedro Franco on 16/10/24
//

import Foundation
import JData

enum PreviewGame {
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
	
	static let regular: Game = .init(
		id: 1,
		name: "Call of Duty",
		releasedAt: 1530519587,
		screenshots: [.init(id: "em1y2ugcwy2myuhvb9db")],
		summary: "Call of Duty is a military video game series and media franchise published by Activision, starting in 2003.",
		rating: .init(value: 10, count: 10),
		platforms: platforms,
		genres: genres
	)
	
	static let imcomplete: Game = .init(
		id: 1,
		name: "Call of Duty",
		releasedAt: 1530519587,
		screenshots: nil,
		summary: "",
		rating: .init(value: 10, count: 10),
		platforms: [],
		genres: []
	)
	
	static let noRatings: Game = .init(
		id: 1,
		name: "Call of Duty",
		releasedAt: 1530519587,
		screenshots: nil,
		summary: "Call of Duty is a military video game series and media franchise published by Activision, starting in 2003.",
		rating: nil,
		platforms: [],
		genres: []
	)
}
