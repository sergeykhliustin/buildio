//
//  RootScreen.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 25.11.2021.
//

import SwiftUI

struct RootScreenItemView: View {
    @EnvironmentObject private var screenFactory: ScreenFactory
    @Environment(\.theme) var theme
    let type: RootScreenItemType
    
    init(_ type: RootScreenItemType) {
        self.type = type
    }
    
    var body: some View {
        let factory = screenFactory
        switch type {
        case .auth:
            EmptyView()
        case .builds:
            factory.buildsScreen(app: nil)
        case .apps:
            factory.appsScreen()
        case .accounts:
            factory.accountsScreen()
        case .activities:
            factory.activitiesScreen()
        case .settings:
            factory.settingsScreen()
        }
    }
}

struct RootScreenItemView_Previews: PreviewProvider {
    static var previews: some View {
        RootScreenItemView(.settings)
    }
}
