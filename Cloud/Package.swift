// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Cloud",
    platforms: [
        .macOS(.v12),
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Cloud",
            targets: [
                "Cloud"
            ]
        )
    ],
    targets: [
        .target(
            name: "Cloud",
            path: "Sources"
        ),
        .testTarget(
            name: "CloudTests",
            dependencies: [
                "Cloud"
            ],
            path: "Tests"
        )
    ]
)
