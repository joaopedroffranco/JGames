//
// Created by Joao Pedro Franco on 17/10/24
//
	
import Foundation

public extension Array where Element == String {
	var asCommaString: String? {
		if isEmpty { return nil }
		return joined(separator: ", ")
	}
	
	var asSlashString: String? {
		if isEmpty { return nil }
		return joined(separator: " / ")
	}
}
