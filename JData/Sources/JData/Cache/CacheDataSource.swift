//
// Created by Joao Pedro Franco on 17/10/24
//


import Foundation
import JFoundation
import CoreData

public protocol CacheDataSourceProtocol {
	func save<T: CoreDataCacheable>(cacheable: T) async
	func update<T: CoreDataCacheable>(cacheable: T) async
	func fetchAll<T: CoreDataCacheable>() async -> [T]?
	func fetch<T: CoreDataCacheable>(key: String) async -> T?
	func clean<T: CoreDataCacheable>(cacheableType: T.Type) async
}

public class CacheDataSource: CacheDataSourceProtocol {
	private let manager: CoreDataManagerProtocol = CoreDataManager.shared
	
	public init() {}
	
	public func save<T: CoreDataCacheable>(cacheable: T) async {
		await manager.add(cacheable: cacheable)
	}
	
	public func update<T: CoreDataCacheable>(cacheable: T) async {
		await manager.delete(cacheable: cacheable)
		await manager.add(cacheable: cacheable)
	}
	
	public func fetchAll<T: CoreDataCacheable>() async -> [T]? {
		await manager.findAll(entityType: T.self)
	}
	
	public func fetch<T: CoreDataCacheable>(key: String) async -> T? {
		await manager.find(key: key)
	}
	
	public func clean<T: CoreDataCacheable>(cacheableType: T.Type) async {
		await manager.clean(type: cacheableType.self)
	}
}
