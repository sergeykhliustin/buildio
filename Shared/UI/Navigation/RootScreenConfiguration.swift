//
//  RootScreenConfiguration.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 25.11.2021.
//

import SwiftUI

struct RootScreenStruct {
    let name: String
    let iconName: String
    var requiresNavigation = true
    let screen: () -> AnyView
}

struct RootScreenV2<Content: View> {
    let name: String
    let iconName: String
    var requiresNavigation = true
    let screen: () -> Content
}

struct RootScreenConfiguration {
#if DEBUG
    static let screens = [
        RootScreens.builds,
        RootScreens.apps,
        RootScreens.accounts,
        RootScreens.activities,
        RootScreens.debug
    ]
#else
    static let screens = [
        RootScreens.builds,
        RootScreens.apps,
        RootScreens.accounts,
        RootScreens.activities
    ]
#endif
}

private struct RootScreens {
    static let builds = RootScreenStruct(name: "Builds", iconName: "hammer") {
        AnyView(BuildsScreenView())
    }
    static let apps = RootScreenStruct(name: "Apps", iconName: "line.3.horizontal.circle") {
        AnyView(AppsScreenView())
    }
    static let accounts = RootScreenStruct(name: "Accounts", iconName: "ellipsis.rectangle") {
        AnyView(AccountsScreenView())
    }
    static let profile = RootScreenStruct(name: "Profile", iconName: "person.crop.circle") {
        AnyView(ProfileScreenView())
    }
    static let activities = RootScreenStruct(name: "Activities", iconName: "bell") {
        AnyView(ActivitiesScreenView())
    }
    #if DEBUG
    static let debug = RootScreenStruct(name: "Debug", iconName: "bolt.heart", requiresNavigation: false) {
        AnyView(DebugLogsScreenView())
    }
    #endif
}
