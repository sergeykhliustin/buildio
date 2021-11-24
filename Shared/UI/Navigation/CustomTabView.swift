//
//  CustomTabView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 05.11.2021.
//

import SwiftUI
import Introspect

private class CustomTabViewModel {
    var cachedViews: [Int: AnyView] = [:]
}

private struct FullscreenEnvironmentKey: EnvironmentKey {
    static var defaultValue: Binding<Bool> = .constant(false)
}

extension EnvironmentValues {
    var fullscreen: Binding<Bool> {
        get {
            self[FullscreenEnvironmentKey.self]
        }
        set {
            self[FullscreenEnvironmentKey.self] = newValue
        }
    }
}

struct CustomTabView: View {
    private let model = CustomTabViewModel()
    let count: Int
    var content: (Int) -> RootScreen
    
    @SceneStorage("tabview.selectedTab") private var selected: Int = 0
    @State private var fullscreen: Bool = false
    @StateObject private var keyboard: KeyboardObserver = KeyboardObserver()
    
#if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
#endif
    
    init(count: Int, content: @escaping (Int) -> RootScreen) {
        self.count = count
        self.content = content
    }
    
    var body: some View {
        #if os(iOS)
        if horizontalSizeClass == .compact {
            buildTabBarNavigation()
        } else {
            buildSidebarNavigation()
        }
        #else
        buildSidebarNavigation()()  // For mac
            .frame(minWidth: 900, maxWidth: .infinity, minHeight: 500, maxHeight: .infinity)
        #endif
    }
    
    @ViewBuilder
    private func buildTabBarNavigation() -> some View {
        VStack(spacing: 0) {
            TabView(selection: $selected) {
                ForEach(0..<count) { index in
                    if content(index).requiresNavigation {
                        NavigationView {
                            content(index).screen()
                                .navigationTitle(content(index).name)
                        }
                        .navigationViewStyle(.stack)
                    } else {
                        content(index).screen()
                    }
                }
            }
            
            if !fullscreen && !keyboard.isVisible {
                CustomTabBar(count: count, selected: $selected, content: { index in
                    Image(systemName: content(index).iconName + (selected == index ? ".fill" : ""))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                    Text(content(index).name)
                        .font(.footnote)
                })
                    .edgesIgnoringSafeArea(.horizontal)
            }
        }
        .environment(\.fullscreen, $fullscreen)
    }
    
    @ViewBuilder
    private func buildSidebarNavigation() -> some View {
        HStack(spacing: 0) {
            if !fullscreen {
                CustomTabBar(style: .vertical, count: count, selected: $selected, content: { index in
                    Image(systemName: content(index).iconName + (selected == index ? ".fill" : ""))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                    Text(content(index).name)
                        .font(.footnote)
                })
                    .edgesIgnoringSafeArea(.vertical)
                    .zIndex(1)
            }
            
            TabView(selection: $selected) {
                ForEach(0..<count) { index in
                    if content(index).requiresNavigation {
                        NavigationView {
                            content(index).screen()
                                .background(Color.white)
                                .navigationTitle(content(index).name)
                        }
                        .introspectSplitViewController { splitViewController in
                            logger.debug(splitViewController)
                            splitViewController.preferredSplitBehavior = .tile
                            splitViewController.primaryBackgroundStyle = .none
                            splitViewController.minimumPrimaryColumnWidth = 300
                            splitViewController.maximumPrimaryColumnWidth = 600
                            
                            if !fullscreen {
                                splitViewController.preferredDisplayMode = .oneOverSecondary
                            }
                            
                            if fullscreen && splitViewController.displayMode != .secondaryOnly {
                                splitViewController.hide(.primary)
                            }
                        }
                    } else {
                        content(index).screen()
                    }
                }
            }
        }
        .statusBar(hidden: fullscreen)
        .environment(\.fullscreen, $fullscreen)
    }
}
