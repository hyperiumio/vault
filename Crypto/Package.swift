// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Crypto",
    platforms: [
        .macOS("12.0"),
        .iOS("15.0")
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
