// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Preferences",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13)
    ],
    products: [
        .library(name: "Preferences", targets: ["Preferences"])
    ],
    targets: [
        .target(name: "Preferences"),
        .testTarget(name: "PreferencesTests", dependencies: ["Preferences"])
    ]
)
