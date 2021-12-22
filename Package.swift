// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BuildioApp",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "BuildioApp",
            targets: ["BuildioApp"])
    ],
    dependencies: [
        .package(name: "BuildioMain", path: "./Modules/BuildioMain")
    ],
    targets: [
        .target(
            name: "BuildioApp",
            dependencies: [
                "BuildioMain"
            ], path: "Shared",
            sources: [])
    ]
)
