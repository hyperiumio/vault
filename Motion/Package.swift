// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Motion",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "Motion", targets: ["Motion"])
    ],
    targets: [
        .target(name: "Motion", path: "Sources"),
        .testTarget(name: "MotionTests", dependencies: ["Motion"], path: "Tests")
    ]
)
