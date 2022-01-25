//
//  ThemeConfiguratorView.swift
//  
//
//  Created by Sergey Khliustin on 10.12.2021.
//

import SwiftUI

private struct ThemeEnvironmentKey: EnvironmentKey {
    static var defaultValue: Theme = Theme.current
}

private struct ThemeUpdaterEnvironmentKey: EnvironmentKey {
    static var defaultValue: Binding<Theme> = .constant(Theme.current)
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
    
    var themeUpdater: Binding<Theme> {
        get {
            self[ThemeUpdaterEnvironmentKey.self]
        }
        set {
            self[ThemeUpdaterEnvironmentKey.self] = newValue
        }
    }
}

struct AppThemeConfiguratorView<Content: View>: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var theme: Theme
    @State private var themeUpdater: Theme = Theme.current
    @ViewBuilder private let content: () -> Content
    private var forcedTheme: Binding<Theme>?
    
    init(forcedTheme: Binding<Theme>? = nil, _ content: @escaping () -> Content) {
        self.forcedTheme = forcedTheme
        _theme = State(initialValue: forcedTheme?.wrappedValue ?? Theme.current)
        self.content = content
        configureAppearance(theme)
    }
    
    var body: some View {
        content()
            .environment(\.theme, theme)
            .environment(\.themeUpdater, $themeUpdater)
            .accentColor(theme.accentColor)
            .foregroundColor(theme.textColor)
            .background(theme.background)
            .progressViewStyle(CircularInfiniteProgressViewStyle())
            .onChange(of: colorScheme, perform: { newValue in
                if forcedTheme == nil {
                    theme = Theme.theme(for: newValue)
                    configureAppearance(theme)
                }
            })
            .onChange(of: $themeUpdater.wrappedValue, perform: { newValue in
                if forcedTheme == nil {
                    theme = newValue
                    configureAppearance(theme)
                }
            })
            .onChange(of: forcedTheme?.wrappedValue, perform: { newValue in
                if let newValue = newValue {
                    theme = newValue
                }
            })
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
