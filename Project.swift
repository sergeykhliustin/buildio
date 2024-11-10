import ProjectDescription
import Foundation

let version: SettingValue = "2.0.0"

let destinations: ProjectDescription.Destinations = [.iPhone, .iPad, .macCatalyst]

let project = Project(
    name: "Buildio",
    options: .options(
        disableBundleAccessors: true,
        disableSynthesizedResourceAccessors: true
    ),
    settings: .settings(base: [
        "SWIFT_VERSION": "6.0",
        "IPHONEOS_DEPLOYMENT_TARGET": "16.0",
        "DEVELOPMENT_TEAM": "6C4646EB2U",
        "GENERATE_INFOPLIST_FILE": "YES",
        "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
        "ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME": "AccentColor",
        "ASSETCATALOG_COMPILER_GENERATE_ASSET_SYMBOLS": "NO",
        "INFOPLIST_KEY_UILaunchStoryboardName": "LaunchScreen",
        "INFOPLIST_KEY_NSCameraUsageDescription": "Required for document and facial capture",
        "MARKETING_VERSION": version,
        "CURRENT_PROJECT_VERSION": "1",
        "SUPPORTS_MACCATALYST": "YES",
        "INFOPLIST_KEY_UISupportedInterfaceOrientations": "UIInterfaceOrientationPortrait UIInterfaceOrientationPortraitUpsideDown UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight",
        "OTHER_LDFLAGS": "$(inherited) -ObjC -all_load"
    ], debug: [
        "OTHER_LDFLAGS": "$(inherited) -Xlinker -interposable"
    ]),
    targets: [
        .target( 
            name: "Buildio",
            destinations: destinations,
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
                .pre(script: "/opt/homebrew/bin/swiftLint", name: "SwiftLint"),
                .post(
                    script: """
                    /opt/homebrew/bin/periphery scan \
                    --workspace "Buildio.xcworkspace" \
                    --schemes "Buildio" \
                    --targets Buildio `ls Modules/Features | tr '\n' ' '` `ls Modules/Core | tr '\n' ' '` `ls Modules/UI | tr '\n' ' '` \
                    --skip-build --index-store-path "${BUILD_DIR}/../../Index.noindex/DataStore/" \
                    --retain-encodable-properties 2>/dev/null || true
                    """,
                    name: "Periphery",
                    shellPath: "/bin/zsh"
                )
            ],
            dependencies: [
                .project(target: "Coordinator", path: "Modules"),
            ]
        )
    ]
)
