//
//  RootTabBarWrapper.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 25.11.2021.
//

import SwiftUI

struct RootTabBarWrapper<Content: View>: View {
    @ViewBuilder private let content: () -> Content
    @Binding private var selection: Int
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
        !fullscreen.wrappedValue && windowMode == .split
    }
    
    private var isBottomBarVisible: Bool {
        !fullscreen.wrappedValue && !keyboard && windowMode == .compact
    }
    
    init(selection: Binding<Int>, _ content: @escaping () -> Content) {
        self._selection = selection
        self.content = content
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
                            CustomTabBar(selected: $selection)
                                .padding(.bottom, proxy.safeAreaInsets.bottom)
                        }
                    
                } secondary: {
                    CustomTabBar(style: .vertical, selected: $selection)
                        .padding(.leading, interfaceOrientation == .landscapeRight ? proxy.safeAreaInsets.leading : 0)
                        .zIndex(1)
                        
                }
                .background(theme.background)
                .ignoresSafeArea()
                .statusBar(hidden: fullscreen.wrappedValue)
        }
    }
}

struct RootTabBarWrapper_Previews: PreviewProvider {
    static var previews: some View {
        RootTabBarWrapper(selection: .constant(0)) {
            Text("wrapped")
        }
    }
}
