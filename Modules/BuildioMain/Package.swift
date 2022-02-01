// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BuildioMain",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "BuildioMain",
            targets: ["BuildioMain"])
    ],
    dependencies: [
        .package(name: "Models", path: "../Models"),
        .package(name: "BitriseAPIs", path: "../BitriseAPIs"),
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "4.0.0"),
        .package(url: "https://github.com/onevcat/Rainbow", from: "4.0.1"),
        .package(url: "https://github.com/gonzalezreal/MarkdownUI", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "BuildioMain",
            dependencies: [
                "KeychainAccess",
                "Rainbow",
                "Models",
                "BitriseAPIs",
                "MarkdownUI"
            ])
    ]
)
