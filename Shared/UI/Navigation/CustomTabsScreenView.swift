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
}

struct CustomTabsScreenView: View {
    let screens = [
        RootScreens.builds,
        RootScreens.apps,
        RootScreens.accounts,
        RootScreens.activities
    ]
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
