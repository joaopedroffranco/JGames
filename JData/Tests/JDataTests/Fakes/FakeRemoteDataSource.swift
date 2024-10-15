//
//  Created by João Pedro Fabiano Franco
//

import Foundation
@testable import JData

public class FakeRemoteDataSource: RemoteDataSourceProtocol {
	let jsonFile: JSONFileProtocol

	init(jsonFile: JSONFileProtocol) {
		self.jsonFile = jsonFile
	}
	
	public func fetch<T: Decodable>(request: Requestable) async throws -> T {
		guard
			let data = get(file: jsonFile),
			let response = try? JSONDecoder().decode(T.self, from: data)
		else {
			throw RemoteDataSourceError.decodeError
		}
		
		return response
	}

	private func get(file: JSONFileProtocol) -> Data? {
		guard let url = Bundle.module.url(
			forResource: file.name,
			withExtension: "json"
		) else {
			return nil
		}

		do {
			let data = try Data(contentsOf: url)
			return data
		} catch {
			return nil
		}
	}
}


