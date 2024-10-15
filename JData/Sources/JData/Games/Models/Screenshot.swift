//
// Created by Joao Pedro Franco on 16/10/24
//

import Foundation
import CoreData

public struct Screenshot: Hashable {
	public let id: String
	
	public var thumbUrl: URL? {
		URL(string: "https://images.igdb.com/igdb/image/upload/t_thumb/\(id).jpg")
	}
	
	public var coverUrl: URL? {
		URL(string: "https://images.igdb.com/igdb/image/upload/t_cover_big/\(id).jpg")
	}
	
	public var regularUrl: URL? {
		URL(string: "https://images.igdb.com/igdb/image/upload/t_screenshot_med/\(id).jpg")
	}
	
	public init(id: String) {
		self.id = id
	}
}

extension Screenshot: Decodable {
	enum CodingKeys: String, CodingKey {
		case id = "image_id"
	}
}

extension Screenshot: CoreDataCacheable {
	public static var entityType: NSManagedObject.Type { ScreenshotEntity.self }
	
	public func newEntity(on context: NSManagedObjectContext) {
		ScreenshotEntity(from: self, context: context)
	}
	
	public init?(from entity: NSManagedObject?) {
		guard let entity = entity as? ScreenshotEntity else { return nil }
		self.id = entity.id
	}
}
