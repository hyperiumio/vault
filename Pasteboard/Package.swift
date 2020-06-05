// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Pasteboard",
    products: [
        .library(name: "Pasteboard", targets: ["Pasteboard"])
    ],
    targets: [
        .target(name: "Pasteboard"),
        .testTarget(name: "PasteboardTests", dependencies: ["Pasteboard"])
    ]
)
