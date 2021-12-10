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

struct ThemeConfiguratorView<Content: View>: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var theme: Theme = ThemeHelper.current
    @ViewBuilder private let content: () -> Content
    
    init(_ content: @escaping () -> Content) {
        self.content = content
        configureAppearance(theme)
    }
    
    var body: some View {
        content()
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
        UIApplication.shared.windows.forEach({
            $0.backgroundColor = UIColor(theme.background)
            $0.rootViewController?.viewIfLoaded?.backgroundColor = UIColor(theme.background)
        })
        UITabBar.appearance().isHidden = true
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithTransparentBackground()
        navigationBarAppearance.backgroundColor = UIColor(theme.background)
        navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(theme.textColor)]
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor(theme.textColor)]
//        navigationBarAppearance.shadowColor = UIColor(Color.b_ShadowLight)
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        UINavigationBar.appearance().tintColor = UIColor(theme.accentColor)
    }
}
