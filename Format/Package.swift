// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "Format",
    platforms: [
        .macOS(.v11),
        .iOS(.v14)
    ],
    products: [
        .library(name: "Format", targets: ["Format"])
    ],
    targets: [
        .target(name: "Format", path: "Sources"),
        .testTarget(name: "FormatTests", dependencies: ["Format"], path: "Tests")
    ]
)
