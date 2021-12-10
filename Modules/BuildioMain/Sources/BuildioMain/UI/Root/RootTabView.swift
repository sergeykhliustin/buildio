//
//  RootTabViewScreen.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 25.11.2021.
//

import SwiftUI
import Introspect

private extension View {
    typealias ContentTransform<Content: View> = (Self) -> Content

    @ViewBuilder
    func conditionalModifier<TrueContent: View, FalseContent: View>(
        _ condition: Bool,
        ifTrue: ContentTransform<TrueContent>,
        ifFalse: ContentTransform<FalseContent>
    ) -> some View {
        if condition {
            ifTrue(self)
        } else {
            ifFalse(self)
        }
    }
}

struct RootTabView: View, RoutingView {
    @Environment(\.theme) private var theme
    @Environment(\.fullscreen) private var fullscreen
    @EnvironmentObject private var navigators: Navigators
//    @EnvironmentObject private var themeObject: ThemeObject
    
    @Binding private var selection: Int
    private let configuration: [RootScreenItemType]
    
    init(selection: Binding<Int>, configuration: [RootScreenItemType] = RootScreenItemType.default) {
        self._selection = selection
        self.configuration = configuration
    }
    
    private var isStack: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
    
    var body: some View {
        TabView(selection: $selection) {
            ForEach(0..<configuration.count) { index in
                let item = configuration[index]
                if item.navigation {
                    NavigationView {
                        RootScreenItemView(item)
                            .navigationTitle(item.name)
                            .background(theme.background)
                    }
                    .tag(index)
                    .introspectNavigationController(customize: { controller in
                        logger.debug("")
                        navigators.set(navigation: controller, for: item)
                        navigators.applyTheme(theme)
                    })
                    .introspectSplitViewController { splitViewController in
                        logger.debug(splitViewController)
                        navigators.set(split: splitViewController, for: item)
                        splitViewController.preferredSplitBehavior = .tile
                        splitViewController.primaryBackgroundStyle = .none
                        splitViewController.minimumPrimaryColumnWidth = 300
                        splitViewController.maximumPrimaryColumnWidth = 600
                        
                        if !fullscreen.wrappedValue {
                            splitViewController.preferredDisplayMode = .oneOverSecondary
                        }
                        
                        if fullscreen.wrappedValue && splitViewController.displayMode != .secondaryOnly {
                            splitViewController.hide(.primary)
                        }
                        
                    }
                } else {
                    RootScreenItemView(item)
                        .tag(index)
                }
            }
        }
    }
}

struct RootTabView_Previews: PreviewProvider {
    static var previews: some View {
        RootTabView(selection: .constant(0))
    }
}
