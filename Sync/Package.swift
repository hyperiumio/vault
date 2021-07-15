// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Sync",
    platforms: [
        .macOS(.v12),
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Sync",
            targets: [
                "Sync"
            ]
        )
    ],
    targets: [
        .target(
            name: "Sync",
            path: "Sources"
        ),
        .testTarget(
            name: "SyncTests",
            dependencies: [
                "Sync"
            ],
            path: "Tests"
        ),
    ]
)
