// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Collection",
    platforms: [
        .macOS(.v12),
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Collection",
            targets: [
                "Collection"
            ]
        )
    ],
    targets: [
        .target(
            name: "Collection",
            path: "Sources"
        )
    ]
)
