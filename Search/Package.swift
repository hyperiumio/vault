// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Search",
    platforms: [
        .macOS(.v11),
        .iOS(.v14)
    ],
    products: [
        .library(name: "Search", targets: ["Search"])
    ],
    targets: [
        .target(name: "Search"),
        .testTarget(name: "SearchTests", dependencies: ["Search"])
    ]
)
