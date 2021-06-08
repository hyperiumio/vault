// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Persistence",
    platforms: [
        .macOS("12.0"),
        .iOS("15.0")
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
        ),
        .testTarget(
            name: "PersistenceTests",
            dependencies: [
                "Persistence"
            ],
            path: "Tests"
        )
    ]
)
