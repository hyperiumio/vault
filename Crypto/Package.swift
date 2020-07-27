// swift-tools-version:5.3

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
        .target(name: "CoreCrypto"),
        .target(name: "Crypto", dependencies: ["CoreCrypto"]),
        .testTarget(name: "CryptoTests", dependencies: ["Crypto"])
    ]
)
