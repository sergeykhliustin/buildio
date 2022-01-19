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

private struct LightThemeEnvironmentKey: EnvironmentKey {
    static var defaultValue: Binding<LightTheme> = .constant(LightTheme())
}

private struct DarkThemeEnvironmentKey: EnvironmentKey {
    static var defaultValue: Binding<DarkTheme> = .constant(DarkTheme())
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
    
    var lightTheme: Binding<LightTheme> {
        get {
            self[LightThemeEnvironmentKey.self]
        }
        set {
            self[LightThemeEnvironmentKey.self] = newValue
        }
    }
    
    var darkTheme: Binding<DarkTheme> {
        get {
            self[DarkThemeEnvironmentKey.self]
        }
        set {
            self[DarkThemeEnvironmentKey.self] = newValue
        }
    }
}

struct AppThemeConfiguratorView<Content: View>: View {
    @EnvironmentObject private var navigators: Navigators
    @Environment(\.colorScheme) var colorScheme
    @State private var theme: Theme = ThemeHelper.current
    @State private var lightTheme: LightTheme = LightTheme()
    @State private var darkTheme: DarkTheme = DarkTheme()
    @ViewBuilder private let content: () -> Content
    
    init(_ content: @escaping () -> Content) {
        self.content = content
        configureAppearance(theme)
    }
    
    var body: some View {
        content()
            .environment(\.theme, theme)
            .environment(\.lightTheme, $lightTheme)
            .environment(\.darkTheme, $darkTheme)
            .accentColor(theme.accentColor)
            .foregroundColor(theme.textColor)
            .background(theme.background)
            .progressViewStyle(CircularInfiniteProgressViewStyle())
            .onChange(of: colorScheme, perform: { newValue in
                theme = ThemeHelper.theme(for: newValue)
                configureAppearance(theme)
            })
            .onChange(of: $lightTheme.wrappedValue, perform: { newValue in
                if colorScheme == .light {
                    theme = newValue
                    configureAppearance(theme)
                }
            })
            .onChange(of: $darkTheme.wrappedValue, perform: { newValue in
                if colorScheme == .dark {
                    theme = newValue
                    configureAppearance(theme)
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
