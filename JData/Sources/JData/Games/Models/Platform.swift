//
// Created by Joao Pedro Franco on 17/10/24
//
	
import Foundation
import CoreData

public struct Platform: Hashable {
	public let name: String
	
	public init(name: String) {
		self.name = name
	}
}

extension Platform: Decodable {}

extension Platform: CoreDataCacheable {
	public static var entityType: NSManagedObject.Type { PlatformEntity.self }
	
	public func newEntity(on context: NSManagedObjectContext) {
		PlatformEntity(from: self, context: context)
	}
	
	public init?(from entity: NSManagedObject?) {
		guard let entity = entity as? PlatformEntity else { return nil }
		self.name = entity.name
	}
}
