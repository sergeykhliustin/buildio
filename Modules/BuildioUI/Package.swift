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
            name: "BuildioUI",
            targets: ["BuildioUI"])
    ],
    dependencies: [
        .package(name: "Models", path: "../Models"),
        .package(name: "BuildioLogic", path: "../BuildioLogic"),
        .package(url: "https://github.com/gonzalezreal/MarkdownUI", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "BuildioUI",
            dependencies: [
                "Models",
                "BuildioLogic",
                "MarkdownUI"
            ])
    ]
)
