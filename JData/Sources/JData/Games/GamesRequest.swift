//
//  Created by Joao Pedro Franco on 16/07/24.
//

import Foundation

enum GamesRequest: Requestable {
	case listOf(page: Int, limit: Int)
	case game(id: Int)
	
	var method: RequestMethod { .post }
	
	var host: String { "https://api.igdb.com/v4" }
	
	var endpoint: String { "/games" }
	
	var params: [String : String]? { nil }
	
	var headers: [String: String]? {
		[
			"Client-ID": "ctgyj1u5eoe8ynxsoi0anhpctz1oo6",
			"Authorization": "Bearer iawmqtbgk5h47jjglcn4v7sofkue9v"
		]
	}
	
	var body: String? {
		switch self {
		case let .listOf(page, limit):
			return "fields first_release_date,name,screenshots.*; limit \(limit); offset \(limit * page);"
		case let .game(id):
			return "fields first_release_date,name,platforms.*,screenshots.*,summary,total_rating,total_rating_count,genres.*; where id = \(id);"
		}
	}
	
	var cachePolicy: URLRequest.CachePolicy { .reloadIgnoringLocalCacheData }
}
