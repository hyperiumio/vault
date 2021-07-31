// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Shim",
    platforms: [
        .macOS(.v12),
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Shim",
            targets: [
                "Shim"
            ]
        )
    ],
    targets: [
        .target(
            name: "Shim",
            path: "Sources"
        )
    ]
)
