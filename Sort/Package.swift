// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Sort",
    platforms: [
        .macOS(.v11),
        .iOS(.v14)
    ],
    products: [
        .library(name: "Sort", targets: ["Sort"])
    ],
    targets: [
        .target(name: "Sort"),
        .testTarget(name: "SortTests", dependencies: ["Sort"]),
    ]
)
