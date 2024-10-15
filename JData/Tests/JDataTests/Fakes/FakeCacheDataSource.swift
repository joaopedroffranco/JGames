//
// Created by Joao Pedro Franco on 19/10/24
//
	
import Foundation
import JData

public class FakeCacheDataSource: CacheDataSourceProtocol {
	
	var cache: [String: CoreDataCacheable]
	
	init(_ initial: [CoreDataCacheable] = []) {
		self.cache = initial.reduce(into: [:]) { $0[$1.key] = $1 }
	}
	
	public func save<T: CoreDataCacheable>(cacheable: T) async {
		cache[cacheable.key] = cacheable
	}
	
	public func update<T: CoreDataCacheable>(cacheable: T) async {
		cache[cacheable.key] = cacheable
	}
	
	public func fetchAll<T: CoreDataCacheable>() async -> [T]? {
		Array(cache.values) as? [T]
	}
	
	public func fetch<T: CoreDataCacheable>(key: String) async -> T? {
		cache[key] as? T
	}
	
	public func clean<T: CoreDataCacheable>(cacheableType: T.Type) async {
		cache = [:]
	}
}
