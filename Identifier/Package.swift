// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Identifier",
    platforms: [
        .macOS(.v11),
        .iOS(.v14)
    ],
    products: [
        .library(name: "Identifier", targets: ["Identifier"])
    ],
    targets: [
        .target(name: "Identifier", path: "Sources"),
        .testTarget(name: "IdentifierTests", dependencies: ["Identifier"], path: "Tests")
    ]
)
