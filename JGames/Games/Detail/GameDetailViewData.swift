//
// Created by Joao Pedro Franco on 16/10/24
//

import Foundation
import JFoundation
import JData

struct GameDetailViewData {
	var id: Int
	var name: String
	var cover: URL?
	var releasedAt: String?
	var summary: String?
	var platforms: String?
	var genres: String?
	var ratingValue: Double?
	var ratingCount: Int?
	var screenshots: [URL]?
	
	var isCached: Bool
	
	var hasAbout: Bool {
		if let summary = summary, !summary.isEmpty { return true }
		return hasGenresOrPlatforms
	}
	
	var hasGenresOrPlatforms: Bool {
		if let genres = genres, !genres.isEmpty { return true }
		if let platforms = platforms, !platforms.isEmpty { return true }

		return false
	}
	
	var hasScreenshots: Bool {
		guard let screenshots = screenshots else { return false }
		return !screenshots.isEmpty
	}
	
	init(
		id: Int,
		name: String,
		cover: URL?,
		releasedAt: String?,
		summary: String?,
		platforms: String?,
		genres: String?,
		ratingValue: Double?,
		ratingCount: Int?,
		screenshots: [URL]?,
		isCached: Bool
	) {
		self.id = id
		self.name = name
		self.cover = cover
		self.releasedAt = releasedAt
		self.summary = summary
		self.platforms = platforms
		self.genres = genres
		self.ratingValue = ratingValue
		self.ratingCount = ratingCount
		self.screenshots = screenshots
		self.isCached = isCached
	}
	
	init(from game: Game, isCached: Bool = false) {
		self.id = game.id
		self.name = game.name
		self.releasedAt = game.releasedAt?.date?.asString
		self.cover = game.cover
		self.summary = game.summary
		self.platforms = game.platforms?.map { $0.name }.asSlashString
		self.genres = game.genres?.map { $0.name }.asCommaString
		self.ratingValue = game.rating?.value
		self.ratingCount = game.rating?.count
		self.screenshots = game.screenshots?.compactMap { $0.regularUrl }
		self.isCached = isCached
	}
}

extension GameDetailViewData: Equatable {}
