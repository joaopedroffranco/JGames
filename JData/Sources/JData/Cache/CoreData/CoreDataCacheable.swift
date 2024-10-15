//
// Created by Joao Pedro Franco on 17/10/24
//
	
import Foundation
import CoreData

public protocol CoreDataCacheable {
	static var entityType: NSManagedObject.Type { get }
	var key: String { get }

	init?(from entity: NSManagedObject?)
	func newEntity(on context: NSManagedObjectContext)
}

public extension CoreDataCacheable {
	var key: String { UUID().uuidString } 
}
