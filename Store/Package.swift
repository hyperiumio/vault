// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Store",
    platforms: [
        .macOS("12.0"),
        .iOS("15.0")
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
