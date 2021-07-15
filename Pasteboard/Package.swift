// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Pasteboard",
    platforms: [
        .macOS(.v12),
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Pasteboard",
            targets: [
                "Pasteboard"
            ]
        )
    ],
    targets: [
        .target(
            name: "Pasteboard",
            path: "Sources"
        ),
        .testTarget(
            name: "PasteboardTests",
            dependencies: [
                "Pasteboard"
            ],
            path: "Tests"
        )
    ]
)
