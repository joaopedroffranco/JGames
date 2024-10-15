//
// Created by Joao Pedro Franco on 24/09/24
//

import Foundation

/// The possible types of HTTP request methods.
public enum RequestMethod {
	case get
	case post
}

/// Protocol for creating requests used in service layers.
///
/// This protocol defines the essential request metadata needed to construct a final URL.
///
/// See `ForecastRequest` for an implementation example.
public protocol Requestable {
	var method: RequestMethod { get }
	var host: String { get }
	var endpoint: String { get }
	var params: [String: String]? { get }
	var headers: [String: String]? { get }
	var body: String? { get }
	var cachePolicy: URLRequest.CachePolicy { get }
	var request: URLRequest? { get }
}

public extension Requestable {
	/// Constructs the final `URLRequest` from a given `Requestable`.
	///
	/// This method generates a `GET` or `POST` request based on the properties defined in the `Requestable`.
	var request: URLRequest? {
		switch method {
		case .get: return getRequest
		case .post: return postRequest
		}
	}

	/// Constructs the first part of the URL.
	private var urlString: String { host + endpoint }

	/// Constructs the rest of the URL, including any query parameters and headers.
	private var getRequest: URLRequest? {
		var urlComponents = URLComponents(string: urlString)
		urlComponents?.queryItems = params?.map {
			URLQueryItem(name: $0.key, value: $0.value)
		}

		guard
			let string = urlComponents?.string,
			let url = URL(string: string)
		else {
			return nil
		}

		var request = URLRequest(url: url, cachePolicy: cachePolicy)
		headers?.forEach {
			request.setValue($0.value, forHTTPHeaderField: $0.key)
		}

		return request
	}

	private var postRequest: URLRequest? {
		guard let url = URL(string: urlString) else { return nil }

		var request = URLRequest(url: url, cachePolicy: cachePolicy)
		headers?.forEach {
			request.setValue($0.value, forHTTPHeaderField: $0.key)
		}
		request.httpMethod = "POST"

		if let body = body {
			request.httpBody = body.data(using: .utf8)
		}

		return request
	}
}
