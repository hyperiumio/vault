// swift-tools-version:5.4

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
        .target(name: "Sort", path: "Sources"),
        .testTarget(name: "SortTests", dependencies: ["Sort"], path: "Tests"),
    ]
)
