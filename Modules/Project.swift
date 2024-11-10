import ProjectDescription
import Foundation

let productType: ProjectDescription.Product = {
    if Environment.static.getBoolean(default: false) {
        return .staticFramework
    } else {
        return .framework
    }
}()

let settings: ProjectDescription.Settings = .settings(
    base: [
        "DERIVE_MACCATALYST_PRODUCT_BUNDLE_IDENTIFIER": "NO",
    ]
)

let destinations: ProjectDescription.Destinations = [.iPhone, .iPad, .macCatalyst]

let core = [
    "Logger",
    "Models",
    "Coordinator",
    "Dependencies",
    "Environment",
    "API",
    "DataProviders"
]

let features = [
    "Auth",
    "Builds",
    "Apps",
    "Activities",
    "Build",
    "BuildYml",
    "Accounts",
    "BuildLog",
    "StartBuild",
    "AbortBuild",
    "Settings",
    "Artifacts",
]

let ui = [
    "Components",
    "Assets",
    "UITypes",
]

let coreTargets: [ProjectDescription.Target] = {
    let dependencies: [String: [TargetDependency]] = [
        "API": [
            .target(name: "Logger"),
            .target(name: "Models")
        ],
        "Coordinator": [
            .external(name: "FlowStacks"),
            .external(name: "Inject"),
            .external(name: "KeychainAccess"),
            .external(name: "SwiftUIIntrospect"),
            .target(name: "Dependencies"),
            .target(name: "Environment"),
            .target(name: "DataProviders"),
        ] + features.map { .target(name: $0) },
        "Dependencies": [
            .target(name: "API"),
            .target(name: "Environment"),
        ],
        "DataProviders": [
            .target(name: "API"),
            .target(name: "Models"),
            .target(name: "Dependencies"),
            .external(name: "AsyncAlgorithms")
        ]
    ]
    let resources: [String: ResourceFileElements] = [
        "API": [
            .folderReference(path: "Core/API/DemoData")
        ]
    ]
    return core.map {
        .target(
            name: $0,
            destinations: destinations,
            product: productType,
            bundleId: "com.sergeyk.module.\($0)",
            sources: "Core/\($0)/**",
            resources: resources[$0],
            dependencies: dependencies[$0, default: []],
            settings: settings
        )
    }
}()

let featureTargets: [ProjectDescription.Target] = {
    let dependencies: [String: [TargetDependency]] = [
        "Build": [
            .external(name: "MarkdownUI"),
        ],
        "BuildLog": [
            .external(name: "Rainbow"),
        ],
    ]
    return features.map {
        .target(
            name: $0,
            destinations: destinations,
            product: productType,
            bundleId: "com.sergeyk.module.\($0)",
            sources: "Features/\($0)/**",
            dependencies: [
                .target(name: "Logger"),
                .target(name: "Models"),
                .target(name: "Dependencies"),
                .target(name: "Components"),
                .target(name: "Assets"),
                .target(name: "UITypes"),
                .target(name: "API"),
            ] + dependencies[$0, default: []],
            settings: settings
        )
    }
}()

let uiTargets: [ProjectDescription.Target] = {
    let dependencies: [String: [TargetDependency]] = [
        "Assets": [
            .target(name: "Environment")
        ],
        "Components": [
            .target(name: "Assets"),
            .target(name: "Models"),
            .external(name: "Kingfisher"),
        ],
        "UITypes": [
            .target(name: "Assets"),
            .target(name: "Dependencies"),
            .target(name: "Components"),
            .target(name: "Models")
        ]
    ]
    return ui.map {
        .target(
            name: $0,
            destinations: destinations,
            product: productType,
            bundleId: "com.sergeyk.module.\($0)",
            sources: "UI/\($0)/**",
            dependencies: [
            ] + dependencies[$0, default: []],
            settings: settings
        )
    }
}()

let project = Project(
    name: "Modules",
    options: .options(
        disableSynthesizedResourceAccessors: true
    ),
    settings: .settings(base: [
        "SWIFT_VERSION": "6.0",
        "IPHONEOS_DEPLOYMENT_TARGET": "16.0",
        "OTHER_SWIFT_FLAGS": "$(inherited) -package-name Modules",
        "DERIVE_MACCATALYST_PRODUCT_BUNDLE_IDENTIFIER": "NO",
        "OTHER_LDFLAGS": "$(inherited) -ObjC -all_load"
    ], debug: [
        "OTHER_LDFLAGS": "$(inherited) -Xlinker -interposable"
    ]),
    targets: featureTargets + uiTargets + coreTargets + [
    ]
)
