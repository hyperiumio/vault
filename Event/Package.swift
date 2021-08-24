// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Event",
    platforms: [
        .macOS(.v12),
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Event",
            targets: [
                "Event"
            ]
        )
    ],
    targets: [
        .target(
            name: "Event",
            path: "Sources"
        )
    ]
)
