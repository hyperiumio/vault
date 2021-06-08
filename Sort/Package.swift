// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Sort",
    platforms: [
        .macOS("12.0"),
        .iOS("15.0")
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
