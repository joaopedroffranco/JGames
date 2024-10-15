//
//  Created by Joao Pedro Franco on 16/07/24.
//

import Foundation
import CoreData

public struct Game: Identifiable, Hashable {
	public let id: Int
	public let name: String
	public let releasedAt: TimeInterval?
	public let screenshots: [Screenshot]?
	public let summary: String?
	public let rating: Rating?
	public let platforms: [Platform]?
	public let genres: [Genre]?
	
	public var thumbnail: URL? { screenshots?.first?.thumbUrl }
	public var cover: URL? { screenshots?.first?.coverUrl }
	
	public init(
		id: Int,
		name: String,
		releasedAt: TimeInterval?,
		screenshots: [Screenshot]?,
		summary: String,
		rating: Rating?,
		platforms: [Platform]?,
		genres: [Genre]?
	) {
		self.id = id
		self.name = name
		self.releasedAt = releasedAt
		self.screenshots = screenshots
		self.summary = summary
		self.rating = rating
		self.platforms = platforms
		self.genres = genres
	}
}

extension Game: Decodable {
	enum CodingKeys: String, CodingKey {
		case id, name, summary, screenshots, platforms, genres
		case releasedAt = "first_release_date"
		case rating = "total_rating", ratingCount = "total_rating_count"
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		self.id = try container.decode(Int.self, forKey: .id)
		self.name = try container.decode(String.self, forKey: .name)
		self.releasedAt = try container.decodeIfPresent(TimeInterval.self, forKey: .releasedAt)
		self.screenshots = try container.decodeIfPresent([Screenshot].self, forKey: .screenshots)
		self.summary = try container.decodeIfPresent(String.self, forKey: .summary)
		self.platforms = try container.decodeIfPresent([Platform].self, forKey: .platforms)
		self.genres = try container.decodeIfPresent([Genre].self, forKey: .genres)
		
		if
			let rating = try? container.decodeIfPresent(Double.self, forKey: .rating),
			let ratingCount = try? container.decodeIfPresent(Int.self, forKey: .ratingCount) {
			self.rating = Rating(value: rating, count: ratingCount)
		} else {
			self.rating = nil
		}
	}
}

extension Game: CoreDataCacheable {
	public var key: String { id.description }
	
	public static var entityType: NSManagedObject.Type { GameEntity.self }
	
	public func newEntity(on context: NSManagedObjectContext) {
		GameEntity(from: self, context: context)
	}
	
	public init?(from entity: NSManagedObject?) {
		guard let entity = entity as? GameEntity else { return nil }
		self.id = Int(entity.id)
		self.name = entity.name
		self.releasedAt = entity.releasedAt
		self.summary = entity.summary ?? ""
		self.rating = Rating(from: entity.rating)
		self.genres = entity.genres?.compactMap { Genre(from: $0) }
		self.platforms = entity.platforms?.compactMap { Platform(from: $0) }
		self.screenshots = entity.screenshots?.compactMap { Screenshot(from: $0) }
	}
}
