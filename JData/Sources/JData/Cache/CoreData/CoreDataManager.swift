//
// Created by Joao Pedro Franco on 17/10/24
//


import Foundation
import CoreData
import JFoundation

public protocol CoreDataManagerProtocol {
	func add<M: CoreDataCacheable>(cacheable: M) async
	func findAll<M: CoreDataCacheable>(entityType: M.Type) async -> [M]?
	func find<M: CoreDataCacheable>(key: String) async -> M?
	func delete<M: CoreDataCacheable>(cacheable: M) async
	func clean<M: CoreDataCacheable>(type: M.Type) async
}

public struct CoreDataManager: CoreDataManagerProtocol {
	public static let shared = CoreDataManager()
	
	var container: NSPersistentContainer = {
		let model = CoreDataManager.createModel()
		let container = NSPersistentContainer(
			name: "Data",
			managedObjectModel: model
		)
		
		container.loadPersistentStores { _, error in
			if let error = error {
				fatalError("Failed to load persistent stores: \(error.localizedDescription)")
			}
		}
		
		return container
	}()
	
	public var context: NSManagedObjectContext
	
	private let logger: Loggable
	
	init(logger: Loggable = Logger.shared) {
		self.logger = logger
		context = container.newBackgroundContext()
		context.automaticallyMergesChangesFromParent = false
	}
	
	public func add<M: CoreDataCacheable>(cacheable: M) async {
		do {
			try await context.perform {
				cacheable.newEntity(on: context)
				if context.hasChanges { try context.save() }
			}
		} catch {
			logger.log(message: CoreDataError.addEntity.rawValue)
		}
	}
	
	public func findAll<M: CoreDataCacheable>(entityType: M.Type) async -> [M]? {
		let request = M.entityType.fetchRequest()
		
		do {
			return try await context.perform {
				let entities = try context.fetch(request) as? [NSManagedObject]
				return entities?.compactMap { M(from: $0) }
			}
		} catch {
			logger.log(message: CoreDataError.findEntity.rawValue)
			return nil
		}
	}
	
	public func find<M: CoreDataCacheable>(key: String) async -> M? {
		let request = M.entityType.fetchRequest()
		let predicate = NSPredicate(format: "id == %@", key)
		request.predicate = predicate
		
		do {
			return try await context.perform {
				guard let entity = (try context.fetch(request) as? [NSManagedObject])?.first else { return nil }
				return M(from: entity)
			}
		} catch {
			logger.log(message: CoreDataError.findEntity.rawValue)
			return nil
		}
	}
	
	public func delete<M: CoreDataCacheable>(cacheable: M) async {
		let request = M.entityType.fetchRequest()
		let predicate = NSPredicate(format: "id == %@", cacheable.key)
		request.predicate = predicate
		
		do {
			try await context.perform {
				guard let entity = (try context.fetch(request) as? [NSManagedObject])?.first else { return }
				context.delete(entity)

				if context.hasChanges { try context.save() }
			}
		} catch {
			logger.log(message: CoreDataError.deleteEntity.rawValue)
		}
	}
	
	public func clean<M: CoreDataCacheable>(type: M.Type) async {
		let request = M.entityType.fetchRequest()
		let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)
		
		do {
			try await context.perform {
				try context.execute(batchDeleteRequest)
				
				if context.hasChanges { try context.save() }
			}
		} catch {
			logger.log(message: CoreDataError.cleanEntity.rawValue)
		}
	}
}

public enum CoreDataError: String, Error {
	case addEntity = "Couldn't update the context"
	case findEntity = "Couldn't find entity"
	case deleteEntity = "Couldn't delete entity"
	case cleanEntity = "Couldn't clean values from an entity"
}
