// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "Crypto",
    platforms: [
        .macOS(.v11),
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "Crypto",
            targets: ["Crypto"]
        )
    ],
    targets: [
        .target(
            name: "Crypto",
            path: "Sources",
            swiftSettings: [
                .unsafeFlags(["-Xfrontend", "-enable-experimental-concurrency"]),
                .unsafeFlags(["-Xfrontend", "-disable-availability-checking"])
            ]
        ),
        .testTarget(
            name: "Tests",
            dependencies: ["Crypto"],
            path: "Tests",
            swiftSettings: [
                .unsafeFlags(["-Xfrontend", "-enable-experimental-concurrency"]),
                .unsafeFlags(["-Xfrontend", "-disable-availability-checking"])
            ]
        )
    ]
)
