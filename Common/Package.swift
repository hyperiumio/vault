// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Common",
    platforms: [
        .macOS(.v12),
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Common",
            targets: [
                "Common"
            ]
        )
    ],
    targets: [
        .target(
            name: "Common",
            path: "Sources"
        ),
        .testTarget(
            name: "CommonTests",
            dependencies: [
                "Common"
            ],
            path: "Tests"
        )
    ]
)
