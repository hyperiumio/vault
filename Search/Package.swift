// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "Search",
    platforms: [
        .macOS(.v11),
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "Search",
            targets: ["Search"]
        )
    ],
    targets: [
        .target(
            name: "Search",
            path: "Sources",
            swiftSettings: [
                .unsafeFlags(["-Xfrontend", "-enable-experimental-concurrency"]),
                .unsafeFlags(["-Xfrontend", "-disable-availability-checking"])
            ]
        ),
        .testTarget(
            name: "SearchTests",
            dependencies: ["Search"],
            path: "Tests",
            swiftSettings: [
                .unsafeFlags(["-Xfrontend", "-enable-experimental-concurrency"]),
                .unsafeFlags(["-Xfrontend", "-disable-availability-checking"])
            ]
        )
    ]
)
