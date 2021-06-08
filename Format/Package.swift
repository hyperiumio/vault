// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Format",
    platforms: [
        .macOS("12.0"),
        .iOS("15.0")
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
