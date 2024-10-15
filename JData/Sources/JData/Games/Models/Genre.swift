//
// Created by Joao Pedro Franco on 17/10/24
//
	
import Foundation
import CoreData

public struct Genre: Hashable {
	public let name: String
	
	public init(name: String) {
		self.name = name
	}
}

extension Genre: Decodable {}

extension Genre: CoreDataCacheable {
	public static var entityType: NSManagedObject.Type { GenreEntity.self }
	
	public func newEntity(on context: NSManagedObjectContext) {
		GenreEntity(from: self, context: context)
	}
	
	public init?(from entity: NSManagedObject?) {
		guard let entity = entity as? GenreEntity else { return nil }
		self.name = entity.name
	}
}
