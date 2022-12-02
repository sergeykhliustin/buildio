//
//  RootTabViewScreen.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 25.11.2021.
//

import SwiftUI
import UIKit

struct RootTabView: View {
    @EnvironmentObject private var screenFactory: ScreenFactory
    @Environment(\.previewMode) private var previewMode
    @Environment(\.theme) private var theme
    @EnvironmentObject private var navigators: Navigators
    
    @Binding private var selection: Int
    
    init(selection: Binding<Int>) {
        self._selection = selection
    }
    
    var body: some View {
        let configuration = previewMode ? RootScreenItemType.preview : RootScreenItemType.default
        TabView(selection: $selection) {
            ForEach(0..<configuration.count) { index in
                let item = configuration[index]
                splitNavigation(for: item)
                    .ignoresSafeArea()
                    .environmentObject(navigators.navigator(for: item))
                    .tag(index)
            }
        }
    }

    @ViewBuilder
    private func splitNavigation(for item: RootScreenItemType) -> some View {
        switch item {
        case .auth:
            EmptyView()
        case .accounts:
            SplitNavigationView(shouldSplit: item.splitNavigation,
                                screen: screenFactory.accountsScreen())
        case .activities:
            SplitNavigationView(shouldSplit: item.splitNavigation,
                                screen: screenFactory.activitiesScreen())
        case .apps:
            SplitNavigationView(shouldSplit: item.splitNavigation,
                                screen: screenFactory.appsScreen())

        case .builds:
            SplitNavigationView(shouldSplit: item.splitNavigation,
                                screen: screenFactory.buildsScreen())
        case .settings:
            SplitNavigationView(shouldSplit: item.splitNavigation,
                                screen: screenFactory.settingsScreen())
        }
    }
}

struct RootTabView_Previews: PreviewProvider {
    static var previews: some View {
        RootTabView(selection: .constant(0))
    }
}
