// swift-tools-version: 6.0

import PackageDescription
import CompilerPluginSupport

let package = Package(
	name: "CaseAccessors",
	platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
	products: [
		.library(name: "CaseAccessors", targets: ["CaseAccessors"]),
	],
	dependencies: [
		.package(url: "https://github.com/swiftlang/swift-syntax", from: "600.0.0"),
	],
	targets: [
		.macro(
			name: "CaseAccessorsMacros",
			dependencies: [
				.product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
				.product(name: "SwiftCompilerPlugin", package: "swift-syntax")
			]
		),
		.target(name: "CaseAccessors", dependencies: ["CaseAccessorsMacros"]),
	]
)
