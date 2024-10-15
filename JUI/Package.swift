// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "JUI",
	platforms: [
		.iOS(.v15)
	],
	products: [
		.library(
			name: "JUI",
			targets: ["JUI"]),
	],
	dependencies: [
		.package(name: "JFoundation", path: "../JFoundation"),
	],
	targets: [
		.target(
			name: "JUI",
			dependencies: ["JFoundation"])
	]
)
