// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Import",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13)
    ],
    products: [
        .library(name: "Import", targets: ["Import"]),
    ],
    targets: [
        .target(name: "Import"),
        .testTarget(name: "ImportTests", dependencies: ["Import"])
    ]
)
