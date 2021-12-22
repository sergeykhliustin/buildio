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
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "4.0.0"),
        .package(url: "https://github.com/onevcat/Rainbow", from: "4.0.1"),
        .package(name: "Introspect", url: "https://github.com/siteline/SwiftUI-Introspect.git", branch: "master"),
        .package(url: "https://github.com/pointfreeco/swiftui-navigation", from: "0.1.0"),
        .package(name: "SwiftyBeaver", url: "https://github.com/SwiftyBeaver/SwiftyBeaver.git", from: "1.9.5")
    ],
    targets: [
        .target(
            name: "Logger",
            dependencies: ["SwiftyBeaver"],
            path: "Modules/Logger/Sources/Logger"
        ),
        .target(
            name: "Models",
            path: "Modules/Models/Sources/Models"
        ),
        .target(
            name: "BitriseAPIs",
            dependencies: ["Models", "Logger"],
            path: "Modules/BitriseAPIs/Sources/BitriseAPIs",
            resources: [
                .copy("DemoData")
            ]
        ),
        .target(
            name: "BuildioMain",
            dependencies: [
                "KeychainAccess",
                "Rainbow",
                "Introspect",
                "Models",
                "BitriseAPIs",
                .product(name: "SwiftUINavigation", package: "swiftui-navigation")
            ], path: "Modules/BuildioMain/Sources/BuildioMain"
        )
    ]
)
