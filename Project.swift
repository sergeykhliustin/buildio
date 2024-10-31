import ProjectDescription
import Foundation

let version: SettingValue = "2.0.0"

let project = Project(
    name: "Buildio",
    options: .options(
        disableBundleAccessors: true,
        disableSynthesizedResourceAccessors: true
    ),
    settings: .settings(base: [
        "IPHONEOS_DEPLOYMENT_TARGET": "15.0",
        "SWIFT_VERSION": "5.0",
        "DEVELOPMENT_TEAM": "6C4646EB2U",
        "GENERATE_INFOPLIST_FILE": "YES",
        "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
        "ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME": "AccentColor",
        "ASSETCATALOG_COMPILER_GENERATE_ASSET_SYMBOLS": "NO",
        "INFOPLIST_KEY_UILaunchStoryboardName": "LaunchScreen",
        "INFOPLIST_KEY_NSCameraUsageDescription": "Required for document and facial capture",
        "MARKETING_VERSION": version,
        "CURRENT_PROJECT_VERSION": "1",
        "OTHER_LDFLAGS": "$(inherited) -ObjC -all_load"
    ], debug: [
        "OTHER_LDFLAGS": "$(inherited) -Xlinker -interposable"
    ]),
    targets: [
        .target( 
            name: "Buildio",
            destinations: .iOS,
            product: .app,
            bundleId: "com.sergeyk.Buildio",
            infoPlist: .file(path: "Buildio.plist"),
            sources: [
                "Shared/**"
            ],
            resources: [
                "Shared/**"
            ],
            entitlements: "Buildio (iOS).entitlements",
            scripts: [
                .pre(script: "/opt/homebrew/bin/swiftLint", name: "SwiftLint")
            ],
            dependencies: [

            ]
        )
    ]
)
