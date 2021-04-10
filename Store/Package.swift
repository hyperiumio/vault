// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "Storage",
    platforms: [
        .macOS(.v11),
        .iOS(.v14)
    ],
    products: [
        .library(name: "Storage", targets: ["Storage"])
    ],
    targets: [
        .target(name: "Storage", path: "Sources", swiftSettings: [.unsafeFlags(["-Xfrontend", "-enable-experimental-concurrency"])]),
        .testTarget(name: "StorageTests", dependencies: ["Storage"], path: "Tests")
    ]
)
