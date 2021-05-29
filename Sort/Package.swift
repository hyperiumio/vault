// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "Sort",
    platforms: [
        .macOS(.v11),
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "Sort",
            targets: ["Sort"]
        )
    ],
    targets: [
        .target(
            name: "Sort",
            path: "Sources",
            swiftSettings: [
                .unsafeFlags(["-Xfrontend", "-enable-experimental-concurrency"]),
                .unsafeFlags(["-Xfrontend", "-disable-availability-checking"])
            ]
        ),
        .testTarget(
            name: "SortTests",
            dependencies: ["Sort"],
            path: "Tests",
            swiftSettings: [
                .unsafeFlags(["-Xfrontend", "-enable-experimental-concurrency"]),
                .unsafeFlags(["-Xfrontend", "-disable-availability-checking"])
            ]
        ),
    ]
)
