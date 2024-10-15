// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "JData",
	platforms: [
		.iOS(.v15)
	],
	products: [
		.library(
			name: "JData",
			targets: ["JData"]),
	],
	dependencies: [
		.package(name: "JFoundation", path: "../JFoundation"),
	],
	targets: [
		.target(
			name: "JData",
			dependencies: ["JFoundation"]),
		.testTarget(
			name: "JDataTests",
			dependencies: ["JData"],
			resources: [.process("JSONs")]
		),
	]
)
