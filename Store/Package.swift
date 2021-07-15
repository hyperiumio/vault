// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Store",
    platforms: [
        .macOS(.v12),
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Store",
            targets: [
                "Store"
            ]
        )
    ],
    targets: [
        .target(
            name: "Store",
            path: "Sources"
        )
    ]
)
