//
//  Created by Joao Pedro Franco on 16/07/24.
//

import Foundation

public protocol JSONFileProtocol {
	var name: String { get }
}

public enum JSONFile: JSONFileProtocol {
	case regular
	case regularSecond
	case regularGame
	case invalid
	case empty

	public var name: String {
		switch self {
		case .regular: return "regular"
		case .regularSecond: return "regular_second"
		case .regularGame: return "regular_game"
		case .invalid: return "invalid"
		case .empty: return "empty"
		}
	}
}
