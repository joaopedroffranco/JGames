//
// Created by Joao Pedro Franco on 25/09/24
//

import Foundation

public extension Date {
	var asString: String {
		let formatter = DateFormatter()
		formatter.dateFormat = "dd.MM.yyyy"
		
		return formatter.string(from: self)
	}
	
	var asYear: String {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy"
		
		return formatter.string(from: self)
	}
}

public extension TimeInterval {
	var date: Date? {
		if self == 0 { return nil }
		return Date(timeIntervalSince1970: self)
	}
}
