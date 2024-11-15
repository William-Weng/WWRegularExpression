// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWRegularExpression",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(name: "WWRegularExpression", targets: ["WWRegularExpression"]),
    ],
    targets: [
        .target(name: "WWRegularExpression"),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
