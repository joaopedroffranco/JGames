//
//  Created by João Pedro Fabiano Franco on 07.09.23.
//

import Foundation
import JFoundation

public protocol RemoteDataSourceProtocol: AnyObject {
	func fetch<T: Decodable>(request: Requestable) async throws -> T
}

public class RemoteDataSource: RemoteDataSourceProtocol {
	private let session: URLSession
	private let decoder: JSONDecoder

	public init(
		session: URLSession = .shared,
		decoder: JSONDecoder = .init()
	) {
		self.session = session
		self.decoder = decoder
	}

	public func fetch<T: Decodable>(request: Requestable) async throws -> T {
		guard let request = request.request else {
			let error = RemoteDataSourceError.invalidRequest
			throw error
		}
		
		let (data, _) = try await session.data(for: request)

		do {
			return try decoder.decode(T.self, from: data)
		} catch {
			let error = RemoteDataSourceError.decodeError
			throw error
		}
	}
}

public enum RemoteDataSourceError: String, Error {
	case invalidRequest = "The request is invalid."
	case decodeError = "Couldn't decode correctly."
	case requestFailed = "The request has failed."
}
