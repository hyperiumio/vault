// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Store",
    platforms: [
        .macOS(.v10_16),
        .iOS(.v14)
    ],
    products: [
        .library(name: "Store", targets: ["Store"])
    ],
    targets: [
        .target(name: "Store"),
        .testTarget(name: "StoreTests", dependencies: ["Store"])
    ]
)
