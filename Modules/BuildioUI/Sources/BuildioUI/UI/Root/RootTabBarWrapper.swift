//
//  RootTabBarWrapper.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 25.11.2021.
//

import SwiftUI

struct RootTabBarWrapper<Content: View>: View {
    @ViewBuilder let content: () -> Content
    @Environment(\.windowMode) private var windowMode
    @Environment(\.keyboard) private var keyboard
    @Environment(\.fullscreen) private var fullscreen
    @EnvironmentObject private var navigators: Navigators
    @Environment(\.theme) var theme
    
    private var interfaceOrientation: UIInterfaceOrientation {
        guard let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation else { return .portrait }
        return orientation
    }
    
    private var isLeftBarVisible: Bool {
        !fullscreen.wrappedValue && windowMode == .split && !(UIDevice.current.userInterfaceIdiom == .phone && navigators.isPresentingModal)
    }
    
    private var isBottomBarVisible: Bool {
        !fullscreen.wrappedValue && !keyboard && windowMode == .compact && !(UIDevice.current.userInterfaceIdiom == .phone && navigators.isPresentingModal)
    }
    
    var body: some View {
        GeometryReader { proxy in
            MainSecondaryOptionalView(
                orientation: .hSecondaryMain,
                isSecondaryVisible: isLeftBarVisible) {
                    MainSecondaryOptionalView(
                        orientation: .vMainSecondary,
                        isSecondaryVisible: isBottomBarVisible) {
                            
                            content()
                            
                        } secondary: {
                            CustomTabBar(selected: $navigators.tabSelection)
                                .padding(.bottom, proxy.safeAreaInsets.bottom)
                        }
                    
                } secondary: {
                    CustomTabBar(style: .vertical, selected: $navigators.tabSelection)
                        .padding(.leading, interfaceOrientation == .landscapeRight ? proxy.safeAreaInsets.leading : 0)
                        .zIndex(1)
                        
                }
                .background(theme.background)
                .ignoresSafeArea()
                .statusBar(hidden: fullscreen.wrappedValue)
        }
    }
}
