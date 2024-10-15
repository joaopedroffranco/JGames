//
//  Created by João Pedro Fabiano Franco
//

import UIKit
import Combine
@testable import JData

/// A mock implementation of `DataSourceProtocol` that returns the expected JSON outcome synchronously for testing purposes.
///
/// This fake data source is used to simulate responses in tests, allowing for controlled and predictable outcomes.
public class FakeDataSource: DataSourceProtocol {
	let jsonFile: JSONFileProtocol

	init(jsonFile: JSONFileProtocol) {
		self.jsonFile = jsonFile
	}
	
	public func fetch<T>(request: Requestable) -> AnyPublisher<T, Error> where T: Decodable {
		guard
			let data = get(file: self.jsonFile),
			let response = try? JSONDecoder().decode(T.self, from: data)
		else {
			return Fail(error: NSError()).eraseToAnyPublisher()
		}

		return Just(response).setFailureType(to: Error.self).eraseToAnyPublisher()
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


