// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Haptic",
    platforms: [
        .macOS(.v12),
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Haptic",
            targets: [
                "Haptic"
            ]
        )
    ],
    targets: [
        .target(
            name: "Haptic",
            path: "Sources"
        )
    ]
)
