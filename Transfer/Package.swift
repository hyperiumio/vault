// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Transfer",
    platforms: [
        .macOS(.v12),
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Transfer",
            targets: [
                "Transfer"
            ]
        )
    ],
    targets: [
        .target(
            name: "Transfer",
            path: "Sources"
        ),
        .testTarget(
            name: "TransferTests",
            dependencies: [
                "Transfer"
            ],
            path: "Tests"
        )
    ]
)
