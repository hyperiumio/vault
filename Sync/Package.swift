// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Sync",
    platforms: [
        .macOS(.v11),
        .iOS(.v14)
    ],
    products: [
        .library(name: "Sync", targets: ["Sync"])
    ],
    targets: [
        .target(name: "Sync", path: "Sources"),
    ]
)
