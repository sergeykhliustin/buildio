// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BuildioUI",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "BuildioUI",
            targets: ["BuildioUI"])
    ],
    dependencies: [
        .package(name: "Models", path: "../Models"),
        .package(name: "BuildioLogic", path: "../BuildioLogic"),
        .package(name: "MarkdownUI", url: "https://github.com/gonzalezreal/swift-markdown-ui", from: "2.0.0")
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
