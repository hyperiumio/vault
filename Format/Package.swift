// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Format",
    platforms: [
        .macOS(.v12),
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Format",
            targets: [
                "Format"
            ]
        )
    ],
    targets: [
        .target(
            name: "Format",
            path: "Sources"
        ),
        .testTarget(
            name: "FormatTests",
            dependencies: [
                "Format"
            ],
            path: "Tests"
        )
    ]
)
