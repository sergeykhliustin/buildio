// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BuildioLogic",
    platforms: [
        .iOS(.v14),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "BuildioLogic",
            targets: ["BuildioLogic"])
    ],
    dependencies: [
        .package(name: "Models", path: "../Models"),
        .package(name: "BitriseAPIs", path: "../BitriseAPIs"),
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "4.0.0"),
        .package(url: "https://github.com/onevcat/Rainbow", from: "4.0.1")
    ],
    targets: [
        .target(
            name: "BuildioLogic",
            dependencies: [
                "KeychainAccess",
                "Rainbow",
                "Models",
                "BitriseAPIs"
            ])
    ]
)
