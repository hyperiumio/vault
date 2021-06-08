// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Search",
    platforms: [
        .macOS("12.0"),
        .iOS("15.0")
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
