// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Configuration",
    platforms: [
        .macOS(.v12),
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Configuration",
            targets: [
                "Configuration"
            ]
        )
    ],
    targets: [
        .target(
            name: "Configuration",
            path: "Sources"
        ),
        .testTarget(
            name: "ConfigurationTests",
            dependencies: [
                "Configuration"
            ],
            path: "Tests"
        )
    ]
)
