// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Crypto",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13)
    ],
    products: [
        .library(name: "Crypto", targets: ["Crypto"])
    ],
    targets: [
        .target(name: "CommonCryptoShim"),
        .target(name: "Crypto", dependencies: ["CommonCryptoShim"]),
        .testTarget(name: "CryptoTests", dependencies: ["Crypto"])
    ]
)
