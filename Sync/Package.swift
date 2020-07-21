// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Sync",
    platforms: [
        .macOS(.v10_16),
        .iOS(.v14)
    ],
    products: [
        .library(name: "Sync", targets: ["Sync"])
    ],
    targets: [
        .target(name: "Sync"),
        .testTarget(name: "SyncTests", dependencies: ["Sync"])
    ]
)
