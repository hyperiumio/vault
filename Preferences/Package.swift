// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Preferences",
    platforms: [
        .macOS("12.0"),
        .iOS("15.0")
    ],
    products: [
        .library(
            name: "Preferences",
            targets: [
                "Preferences"
            ]
        )
    ],
    targets: [
        .target(
            name: "Preferences",
            path: "Sources"
        ),
        .testTarget(
            name: "PreferencesTests",
            dependencies: [
                "Preferences"
            ],
            path: "Tests"
        )
    ]
)
