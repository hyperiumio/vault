// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Localization",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v11),
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
 
