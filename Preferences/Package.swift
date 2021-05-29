// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "Preferences",
    platforms: [
        .macOS(.v11),
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "Preferences",
            targets: ["Preferences"]
        )
    ],
    targets: [
        .target(
            name: "Preferences",
            path: "Sources",
            swiftSettings: [
                .unsafeFlags(["-Xfrontend", "-enable-experimental-concurrency"]),
                .unsafeFlags(["-Xfrontend", "-disable-availability-checking"])
            ]
        ),
        .testTarget(
            name: "PreferencesTests",
            dependencies: ["Preferences"],
            path: "Tests",
            swiftSettings: [
                .unsafeFlags(["-Xfrontend", "-enable-experimental-concurrency"]),
                .unsafeFlags(["-Xfrontend", "-disable-availability-checking"])
            ]
        )
    ]
)
