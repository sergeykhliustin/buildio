//
//  CustomTabsScreenView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 05.11.2021.
//

import SwiftUI

struct RootScreen {
    let name: String
    let iconName: String
    let screen: () -> AnyView
}

private struct RootScreens {
    static let builds = RootScreen(name: "Builds", iconName: "hammer.fill") {
        AnyView(BuildsScreenView())
    }
    static let apps = RootScreen(name: "Apps", iconName: "apps.iphone") {
        AnyView(AppsScreenView())
    }
    static let accounts = RootScreen(name: "Accounts", iconName: "ellipsis.rectangle") {
        AnyView(AccountsScreenView())
    }
    static let profile = RootScreen(name: "Profile", iconName: "person.crop.circle.fill") {
        AnyView(ProfileScreenView())
    }
    static let activities = RootScreen(name: "Activities", iconName: "bell") {
        AnyView(ActivitiesScreenView())
    }
    #if DEBUG
    static let debug = RootScreen(name: "Debug", iconName: "pencil.slash") {
        AnyView(DebugLogsScreenView())
    }
    #endif
}

struct CustomTabsScreenView: View {
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
    var body: some View {
        CustomTabView(count: screens.count) { index in
            screens[index]
        }
    }
}

struct CustomTabsScreenView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabsScreenView()
    }
}
