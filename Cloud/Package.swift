// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "Cloud",
    platforms: [
        .macOS(.v11),
        .iOS(.v14)
    ],
    products: [
        .library(name: "Cloud", targets: ["Cloud"])
    ],
    targets: [
        .target(name: "Cloud", path: "Sources")
    ]
)
