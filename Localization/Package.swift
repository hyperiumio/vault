// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Localization",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v10_16),
        .iOS(.v14)
    ],
    products: [
        .library(name: "Localization", targets: ["Localization"])
    ],
    targets: [
        .target(name: "Localization", resources: [.copy("en.lproj")]),
        .testTarget(name: "LocalizationTests", dependencies: ["Localization"])
    ]
)
 
