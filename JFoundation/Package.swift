// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "JFoundation",
	platforms: [
		.iOS(.v15)
	],
	products: [
		.library(
			name: "JFoundation",
			targets: ["JFoundation"]),
	],
	dependencies: [],
	targets: [
		.target(
			name: "JFoundation",
			dependencies: []),
	]
)
