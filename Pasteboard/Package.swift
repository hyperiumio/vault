// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Pasteboard",
    platforms: [
        .macOS(.v11),
        .iOS(.v14)
    ],
    products: [
        .library(name: "Pasteboard", targets: ["Pasteboard"])
    ],
    targets: [
        .target(name: "Pasteboard", path: "Sources"),
        .testTarget(name: "PasteboardTests", dependencies: ["Pasteboard"], path: "Tests")
    ]
)
