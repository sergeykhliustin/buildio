// swift-tools-version: 5.10
import PackageDescription

#if TUIST
import ProjectDescription

func productType() -> ProjectDescription.Product {
    if Environment.static.getBoolean(default: false) {
        return .staticFramework
    } else {
        return .framework
    }
}

let packageSettings = PackageSettings(
    productTypes: [
        "KeychainAccess": productType(),
        "Rainbow": productType(),
        "MarkdownUI": productType(),
        "Inject": productType(),
        "InternalCollectionsUtilities": productType(),
        "FlowStacks": productType(),
        "SwiftUIIntrospect": productType(),
        "AsyncAlgorithms": productType(),
        "Kingfisher": productType()
    ]
)
#endif

@MainActor
let package = Package(
    name: "PackageName",
    dependencies: [
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "4.0.0"),
        .package(url: "https://github.com/onevcat/Rainbow", from: "4.0.1"),
        .package(url: "https://github.com/gonzalezreal/swift-markdown-ui", exact: "2.4.0"),
        .package(url: "https://github.com/krzysztofzablocki/Inject.git", from: "1.5.2"),
        .package(url: "git@github.com:johnpatrickmorgan/FlowStacks.git", from: "0.8.3"),
        .package(url: "git@github.com:siteline/swiftui-introspect.git", exact: "1.3.0"),
        .package(url: "git@github.com:apple/swift-async-algorithms.git", from: "1.0.0"),
        .package(url: "git@github.com:onevcat/Kingfisher.git", from: "8.1.0")
    ]
)
