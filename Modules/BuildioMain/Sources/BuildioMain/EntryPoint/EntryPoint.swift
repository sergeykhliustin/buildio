//
//  SwiftUIView.swift
//  
//
//  Created by Sergey Khliustin on 26.11.2021.
//

import SwiftUI

public struct EntryPoint: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.colorScheme.theme) var theme
    
    public init() {
        configureAppearance(theme)
    }
    
    public var body: some View {
        EnvironmentConfiguratorView {
            AuthResolverScreenView()
        }
        .accentColor(theme.accentColor)
        .foregroundColor(theme.textColor)
        .background(theme.background)
        .progressViewStyle(CircularInfiniteProgressViewStyle())
        .introspectViewController { controller in
            #if targetEnvironment(macCatalyst)
            let window = controller.viewIfLoaded?.window
            window?.windowScene?.titlebar?.titleVisibility = .hidden
            window?.windowScene?.titlebar?.toolbar?.isVisible = false
            window?.windowScene?.titlebar?.separatorStyle = .none
            #endif
        }
        .onChange(of: colorScheme) { newValue in
            configureAppearance(newValue.theme)
        }
    }
    
    func configureAppearance(_ theme: Theme) {
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
