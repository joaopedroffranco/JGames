//
// Created by Joao Pedro Franco on 17/10/24
//


import Foundation
import JFoundation
import CoreData

public protocol CacheDataSourceProtocol {
	func save<T: CoreDataCacheable>(cacheable: T) async
	func update<T: CoreDataCacheable>(id: Int, cacheable: T) async
	func fetch<T: CoreDataCacheable>() async -> [T]?
	func fetch<T: CoreDataCacheable>(id: Int) async -> T?
	func clean(entityType: CoreDataCacheable.Type) async
}

public class CacheDataSource: CacheDataSourceProtocol {
	private let manager: CoreDataManager = .shared // TODO change name
	private let logger: Loggable
	
	public init(logger: Loggable = Logger.shared) {
		self.logger = logger
	}
	
	public func save<T: CoreDataCacheable>(cacheable: T) async {
		await manager.add(cacheable: cacheable)
	}
	
	public func update<T: CoreDataCacheable>(id: Int, cacheable: T) async {
		await manager.delete(id: id, entityType: T.self)
		await manager.add(cacheable: cacheable)
	}
	
	public func fetch<T: CoreDataCacheable>() async -> [T]? {
		await manager.find(entityType: T.self)
	}
	
	public func fetch<T: CoreDataCacheable>(id: Int) async -> T? {
		await manager.find(id: id, entityType: T.self)
	}
	
	public func clean(entityType: CoreDataCacheable.Type) async {
		await manager.clean(type: entityType.entityType)
	}
}

public enum CacheDataSourceError: String, Error {
	case updateContext = "Couldn't update the context"
	case invalidRequest = "Couldn't fetch request"
	case hitCache = "Couldn't hit the cache"
	case cleanCache = "Couldn't clean the cache"
}
