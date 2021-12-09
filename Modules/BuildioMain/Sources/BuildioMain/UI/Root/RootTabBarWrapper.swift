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
    @Environment(\.keyboard) private var keyboard
    @Environment(\.fullscreen) private var fullscreen
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @EnvironmentObject private var navigators: Navigators
    
    private var interfaceOrientation: UIInterfaceOrientation {
        guard let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation else { return .portrait }
        return orientation
    }
    
    private var isLeftBarVisible: Bool {
        !fullscreen.wrappedValue && horizontalSizeClass == .regular
    }
    
    private var isBottomBarVisible: Bool {
        !fullscreen.wrappedValue && !keyboard && horizontalSizeClass == .compact
    }
    
    init(selection: Binding<Int>, _ content: @escaping () -> Content) {
        self._selection = selection
        self.content = content
    }
    
    var body: some View {
        MainSecondaryOptionalView(
            orientation: .hSecondaryMain,
            isSecondaryVisible: isLeftBarVisible) {
                MainSecondaryOptionalView(
                    orientation: .vMainSecondary,
                    isSecondaryVisible: isBottomBarVisible) {
                        
                        content()
                        
                    } secondary: {
                        CustomTabBar(selected: $selection)
                            .edgesIgnoringSafeArea(.horizontal)
                    }
                
            } secondary: {
                CustomTabBar(style: .vertical, selected: $selection)
                    .edgesIgnoringSafeArea(interfaceOrientation == .landscapeLeft ? [.vertical, .leading] : [.vertical])
                    .zIndex(1)
            }
            .edgesIgnoringSafeArea(interfaceOrientation == .landscapeLeft ? [.leading] : [])
            .statusBar(hidden: fullscreen.wrappedValue)
            .onChange(of: horizontalSizeClass) { _ in
                navigators.fixEmptyNavigation()
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
