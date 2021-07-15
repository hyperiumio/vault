// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Model",
    platforms: [
        .macOS(.v12),
        .iOS(.v15)
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
