// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BuildioUI",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "BuildioUI",
            targets: ["BuildioUI"]),
    ],
    dependencies: [
        .package(name: "Models", path: "../Models"),
        .package(name: "BitriseAPIs", path: "../BitriseAPIs"),
        
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "4.0.0"),
        .package(url: "https://github.com/onevcat/Rainbow", from: "4.0.1"),
        .package(name: "Introspect", url: "https://github.com/siteline/SwiftUI-Introspect.git", branch: "master")
    ],
    targets: [
        .target(
            name: "BuildioUI",
            dependencies: ["KeychainAccess", "Rainbow", "Introspect", "Models", "BitriseAPIs"]),
    ]
)
