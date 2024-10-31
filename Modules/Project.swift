import ProjectDescription
import Foundation

let productType: ProjectDescription.Product = {
    if Environment.static.getBoolean(default: false) {
        return .staticLibrary
    } else {
        return .framework
    }
}()

let project = Project(
    name: "Modules",
    options: .options(
        disableSynthesizedResourceAccessors: true
    ),
    settings: .settings(base: [
        "IPHONEOS_DEPLOYMENT_TARGET": "15.0",
        "SWIFT_VERSION": "5.0",
        "OTHER_SWIFT_FLAGS": "$(inherited) -package-name EXZIModules"
    ], debug: [
        "OTHER_LDFLAGS": "$(inherited) -Xlinker -interposable"
    ]),
    targets: [
        .target(
            name: "Logger",
            destinations: [.iPhone],
            product: productType,
            bundleId: "com.sergeyk.module.Logger",
            sources: "Logger/**"
        ),
        .target(
            name: "Models",
            destinations: [.iPhone],
            product: productType,
            bundleId: "com.sergeyk.module.Models",
            sources: "Models/**"
        ),
        .target(
            name: "BitriseAPIs",
            destinations: [.iPhone],
            product: productType,
            bundleId: "com.sergeyk.module.BitriseAPIs",
            sources: "BitriseAPIs/**",
            resources: [
                .folderReference(path: "BitriseAPIs/DemoData")
            ]
        ),
    ]
)
