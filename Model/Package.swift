// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Model",
    platforms: [
        .macOS("12.0"),
        .iOS("15.0")
    ],
    products: [
        .library(
            name: "Model",
            targets: [
                "Model"
            ]
        )
    ],
    targets: [
        .target(
            name: "Model",
            path: "Sources"
        ),
        .testTarget(
            name: "ModelTests",
            dependencies: [
                "Model"
            ],
            path: "Tests"
        )
    ]
)
