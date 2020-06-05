// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Search",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13)
    ],
    products: [
        .library(name: "Search", targets: ["Search"])
    ],
    targets: [
        .target(name: "Search"),
        .testTarget(name: "SearchTests", dependencies: ["Search"])
    ]
)
