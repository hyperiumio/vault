// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Search",
    platforms: [
        .macOS(.v12),
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Search",
            targets: [
                "Search"
            ]
        )
    ],
    targets: [
        .target(
            name: "Search",
            path: "Sources"
        ),
        .testTarget(
            name: "SearchTests",
            dependencies: [
                "Search"
            ],
            path: "Tests"
        )
    ]
)
