// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Haptic",
    platforms: [
        .macOS(.v11),
        .iOS(.v14)
    ],
    products: [
        .library(name: "Haptic", targets: ["Haptic"])
    ],
    targets: [
        .target(name: "Haptic", path: "Sources")
    ]
)
