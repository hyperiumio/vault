// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Asset",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v12),
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Asset",
            targets: [
                "Asset"
            ]
        )
    ],
    targets: [
        .target(
            name: "Asset",
            path: "Sources"
        )
    ]
)
