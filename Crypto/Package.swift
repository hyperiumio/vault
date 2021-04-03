// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "Crypto",
    platforms: [
        .macOS(.v11),
        .iOS(.v14)
    ],
    products: [
        .library(name: "Crypto", targets: ["Crypto"])
    ],
    targets: [
        .target(name: "Crypto", path: "Sources", swiftSettings: [.unsafeFlags(["-Xfrontend", "-enable-experimental-concurrency"])]),
        .testTarget(name: "CryptoTests", dependencies: ["Crypto"], path: "Tests")
    ]
)
