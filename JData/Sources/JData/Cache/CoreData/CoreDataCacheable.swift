//
// Created by Joao Pedro Franco on 17/10/24
//
	
import Foundation
import CoreData

public protocol CoreDataCacheable {
	static var entityType: NSManagedObject.Type { get }
	func newEntity(on context: NSManagedObjectContext)
	init?(from entity: NSManagedObject?)
}
