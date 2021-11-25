// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BitriseAPIs",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "BitriseAPIs",
            targets: ["BitriseAPIs"])
    ],
    dependencies: [
        .package(path: "../Models"),
        .package(path: "../Logger")
    ],
    targets: [
        .target(
            name: "BitriseAPIs",
            dependencies: ["Models", "Logger"])
    ]
)
