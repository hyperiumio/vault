// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Model",
    platforms: [
        .macOS(.v11),
        .iOS(.v14)
    ],
    products: [
        .library(name: "Model", targets: ["Model"])
    ],
    targets: [
        .target(name: "Model"),
        .testTarget(name: "ModelTests", dependencies: ["Model"])
    ]
)
