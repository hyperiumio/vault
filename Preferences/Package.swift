// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Preferences",
    platforms: [
        .macOS(.v11),
        .iOS(.v14)
    ],
    products: [
        .library(name: "Preferences", targets: ["Preferences"])
    ],
    targets: [
        .target(name: "Preferences", path: "Sources"),
        .testTarget(name: "PreferencesTests", dependencies: ["Preferences"], path: "Tests")
    ]
)
