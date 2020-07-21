// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Preferences",
    platforms: [
        .macOS(.v10_16),
        .iOS(.v14)
    ],
    products: [
        .library(name: "Preferences", targets: ["Preferences"])
    ],
    targets: [
        .target(name: "Preferences"),
        .testTarget(name: "PreferencesTests", dependencies: ["Preferences"])
    ]
)
