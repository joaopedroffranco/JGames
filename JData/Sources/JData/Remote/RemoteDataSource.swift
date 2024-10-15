//
//  Created by João Pedro Fabiano Franco on 07.09.23.
//

import Foundation
import JFoundation

public protocol RemoteDataSourceProtocol: AnyObject {
	func fetch<T: Decodable>(request: Requestable) async throws -> T
}

/// Conforms to `DataSourceProtocol` and wraps the native `URLSession` for data fetching.
///
/// This implementation uses `Combine` to align with the app's reactive approach.
public class RemoteDataSource: RemoteDataSourceProtocol {
	private let session: URLSession
	private let decoder: JSONDecoder
	private let logger: Loggable
	
	/// It utilizes the common `.shared` session, but allows for dependency injection of a custom session for testing purposes.
	public init(
		session: URLSession = .shared,
		decoder: JSONDecoder = .init(),
		logger: Loggable = Logger.shared
	) {
		self.session = session
		self.decoder = decoder
		self.logger = logger
	}
	
	/// Fetches data based on a given `Requestable` and decodes it into a `Decodable` type.
	///
	/// - Parameter request: An instance conforming to `Requestable`.
	/// - Returns: A `RemotePublisher` that publishes the decoded `Decodable` data
	public func fetch<T: Decodable>(request: Requestable) async throws -> T {
		guard let request = request.request else {
			let error = RemoteDataSourceError.invalidRequest
			logger.log(message: error.rawValue)
			throw error
		}
		
		let (data, _) = try await session.data(for: request)

		do {
			return try decoder.decode(T.self, from: data)
		} catch {
			let error = RemoteDataSourceError.decodeError
			logger.log(message: error.rawValue)
			throw error
		}
	}
}

/// Possible errors for a remote data source.
public enum RemoteDataSourceError: String, Error {
	case invalidRequest = "The request is invalid."
	case decodeError = "Couldn't decode correctly."
	case requestFailed = "The request has failed."
}
