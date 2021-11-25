//
//  RootScreenConfiguration.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 25.11.2021.
//

import SwiftUI

struct RootScreen {
    let name: String
    let iconName: String
    var requiresNavigation = true
    let screen: () -> AnyView
}

struct RootScreenConfiguration {
#if DEBUG
    let screens = [
        RootScreens.builds,
        RootScreens.apps,
        RootScreens.accounts,
        RootScreens.activities,
        RootScreens.debug
    ]
#else
    let screens = [
        RootScreens.builds,
        RootScreens.apps,
        RootScreens.accounts,
        RootScreens.activities
    ]
#endif
}

private struct RootScreens {
    static let builds = RootScreen(name: "Builds", iconName: "hammer") {
        AnyView(BuildsScreenView())
    }
    static let apps = RootScreen(name: "Apps", iconName: "line.3.horizontal.circle") {
        AnyView(AppsScreenView())
    }
    static let accounts = RootScreen(name: "Accounts", iconName: "ellipsis.rectangle") {
        AnyView(AccountsScreenView())
    }
    static let profile = RootScreen(name: "Profile", iconName: "person.crop.circle") {
        AnyView(ProfileScreenView())
    }
    static let activities = RootScreen(name: "Activities", iconName: "bell") {
        AnyView(ActivitiesScreenView())
    }
    #if DEBUG
    static let debug = RootScreen(name: "Debug", iconName: "bolt.heart", requiresNavigation: false) {
        AnyView(DebugLogsScreenView())
    }
    #endif
}
