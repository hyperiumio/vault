// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Crypto",
    platforms: [
        .macOS(.v12),
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Crypto",
            targets: [
                "Crypto"
            ]
        )
    ],
    targets: [
        .target(
            name: "Crypto",
            path: "Sources"
        ),
        .testTarget(
            name: "CryptoTests",
            dependencies: [
                "Crypto"
            ],
            path: "Tests"
        )
    ]
)
