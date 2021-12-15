//
//  ThemeConfiguratorView.swift
//  
//
//  Created by Sergey Khliustin on 10.12.2021.
//

import SwiftUI

private struct ThemeEnvironmentKey: EnvironmentKey {
    static var defaultValue: Theme = LightTheme()
}

extension EnvironmentValues {
    var theme: Theme {
        get {
            self[ThemeEnvironmentKey.self]
        }
        set {
            self[ThemeEnvironmentKey.self] = newValue
        }
    }
}

struct AppThemeConfiguratorView<Content: View>: View {
    @EnvironmentObject private var navigators: Navigators
    @Environment(\.colorScheme) var colorScheme
    @State private var theme: Theme = ThemeHelper.current
    @ViewBuilder private let content: () -> Content
    
    init(_ content: @escaping () -> Content) {
        self.content = content
        configureAppearance(theme)
    }
    
    var body: some View {
        ThemeConfiguratorView {
            content()
        }
        .onChange(of: colorScheme, perform: { newValue in
            theme = ThemeHelper.theme(for: newValue)
            configureAppearance(theme)
        })
        .environment(\.theme, theme)
        .accentColor(theme.accentColor)
        .foregroundColor(theme.textColor)
        .background(theme.background)
        .progressViewStyle(CircularInfiniteProgressViewStyle())
    }
    
    func configureAppearance(_ theme: Theme) {
        UITabBar.appearance().isHidden = true
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithTransparentBackground()
        navigationBarAppearance.backgroundColor = UIColor(theme.background)
        navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: theme.textColor.uiColor]
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: theme.textColor.uiColor]
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
    }
}
