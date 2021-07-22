// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Resource",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v12),
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Resource",
            targets: [
                "Resource"
            ]
        )
    ],
    targets: [
        .target(
            name: "Resource",
            path: "Sources"
        )
    ]
)
