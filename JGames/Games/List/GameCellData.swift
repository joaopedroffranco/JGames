//
// Created by Joao Pedro Franco on 17/10/24
//

import Foundation
import JFoundation
import JData

struct GameCellData {
	let id: Int
	let image: URL?
	let name: String
	let year: String?
	
	init(id: Int, image: URL?, name: String, year: String) {
		self.id = id
		self.image = image
		self.name = name
		self.year = year
	}
	
	init(from game: Game) {
		self.id = game.id
		self.image = game.thumbnail
		self.name = game.name
		self.year = game.releasedAt?.date?.asYear
	}
}

extension GameCellData: Hashable {
	static func == (lhs: GameCellData, rhs: GameCellData) -> Bool {
		lhs.id == rhs.id
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}
