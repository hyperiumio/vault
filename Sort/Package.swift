// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Sort",
    platforms: [
        .macOS(.v12),
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Sort",
            targets: [
                "Sort"
            ]
        )
    ],
    targets: [
        .target(
            name: "Sort",
            path: "Sources"
        ),
        .testTarget(
            name: "SortTests",
            dependencies: [
                "Sort"
            ],
            path: "Tests"
        ),
    ]
)
