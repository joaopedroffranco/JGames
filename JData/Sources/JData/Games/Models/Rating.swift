//
// Created by Joao Pedro Franco on 24/09/24
//

import Foundation
import CoreData

public struct Rating: Hashable {
	public let value: Double
	public let count: Int
	
	public init(value: Double, count: Int) {
		self.value = value
		self.count = count
	}
}

extension Rating: CoreDataCacheable {
	public static var entityType: NSManagedObject.Type { RatingEntity.self }
	
	public func newEntity(on context: NSManagedObjectContext) {
		RatingEntity(from: self, context: context)
	}
	
	public init?(from entity: NSManagedObject?) {
		guard let entity = entity as? RatingEntity else { return nil }
		self.value = entity.value
		self.count = entity.count
	}
}
