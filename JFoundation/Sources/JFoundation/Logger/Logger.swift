//
// Created by Joao Pedro Franco on 16/10/24
//
	
import Foundation

public protocol Loggable {
	func log(message: String, step: String, line: Int)
}

public extension Loggable {
	func log(message: String, step: String = #file, line: Int = #line) {
		log(message: message, step: step, line: line)
	}
}

public class Logger: Loggable {
	public static let shared: Logger = .init()

	public init() {}
	
	public func log(message: String, step: String, line: Int) {
		print("[LOG]: ", line, step, message)
	}
}
