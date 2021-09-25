// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Visualization",
    platforms: [
        .macOS(.v12),
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Visualization",
            targets: [
                "Visualization"
            ]
        )
    ],
    targets: [
        .target(
            name: "Visualization",
            path: "Sources"
        )
    ]
)
