//
//  Created by Joao Pedro Franco on 16/07/24.
//

import Foundation

public protocol JSONFileProtocol {
	var name: String { get }
}

/// This enum provides a clear and organized way to reference JSON file names in the application.
public enum JSONFile: JSONFileProtocol {
	case regular
	case regularNoPrecipitationAndAlerts
	case regularNoCondition
	case irregularWeather
	case irregular
	case empty

	public var name: String {
		switch self {
		case .regular: return "regular"
		case .regularNoPrecipitationAndAlerts: return "regular_no_precipitation_alerts"
		case .regularNoCondition: return "regular_no_condition"
		case .irregularWeather: return "irregular_weather"
		case .irregular: return "irregular"
		case .empty: return "empty"
		}
	}
}
