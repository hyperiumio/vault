// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Persistence",
    platforms: [
        .macOS(.v12),
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Persistence",
            targets: [
                "Persistence"
            ]
        )
    ],
    targets: [
        .target(
            name: "Persistence",
            path: "Sources"
        )
    ]
)
