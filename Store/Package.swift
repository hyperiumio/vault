// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Store",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13)
    ],
    products: [
        .library(name: "Store", targets: ["Store"])
    ],
    targets: [
        .target(name: "Store"),
        .testTarget(name: "StoreTests", dependencies: ["Store"])
    ]
)
