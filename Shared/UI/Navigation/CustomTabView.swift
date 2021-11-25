//
//  CustomTabView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 05.11.2021.
//

import SwiftUI
import Introspect

private struct FullscreenEnvironmentKey: EnvironmentKey {
    static var defaultValue: Binding<Bool> = .constant(false)
}

struct CustomTabView: View {
    let count: Int
    var content: (Int) -> RootScreenStruct
    
    @State private var selected: Int = 0
    @Environment(\.keyboard) private var keyboard
    @Environment(\.fullscreen) private var fullscreen
    
    var interfaceOrientation: UIInterfaceOrientation {
        guard let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation else { return .portrait }
        return orientation
    }
    
#if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
#endif
    
    init(count: Int, content: @escaping (Int) -> RootScreenStruct) {
        self.count = count
        self.content = content
    }
    
    var body: some View {
#if os(iOS)
        buildSidebarNavigation()
#else
        buildSidebarNavigation()  // For mac
            .frame(minWidth: 900, maxWidth: .infinity, minHeight: 500, maxHeight: .infinity)
#endif
    }
    
    @ViewBuilder
    private func buildSidebarNavigation() -> some View {
        MainSecondaryOptionalView(
            orientation: .hSecondaryMain,
            isSecondaryVisible: !fullscreen.wrappedValue && horizontalSizeClass == .regular) {
                MainSecondaryOptionalView(
                    orientation: .vMainSecondary,
                    isSecondaryVisible: !fullscreen.wrappedValue && !keyboard && horizontalSizeClass == .compact) {
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
                                        
                                        if !fullscreen.wrappedValue {
                                            splitViewController.preferredDisplayMode = .oneOverSecondary
                                        }
                                        
                                        if fullscreen.wrappedValue && splitViewController.displayMode != .secondaryOnly {
                                            splitViewController.hide(.primary)
                                        }
                                    }
                                } else {
                                    content(index).screen()
                                }
                            }
                        }
                    } secondary: {
                        CustomTabBar(selected: $selected)
                            .edgesIgnoringSafeArea(.horizontal)
                    }
                
            } secondary: {
                CustomTabBar(style: .vertical, selected: $selected)
                    .edgesIgnoringSafeArea(interfaceOrientation == .landscapeLeft ? [.vertical, .leading] : [.vertical])
                    .zIndex(1)
            }
            .edgesIgnoringSafeArea(interfaceOrientation == .landscapeLeft ? [.leading] : [])
            .statusBar(hidden: fullscreen.wrappedValue)
    }
}
