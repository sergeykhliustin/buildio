//
//  SwiftUIView.swift
//  
//
//  Created by Sergey Khliustin on 26.11.2021.
//

import SwiftUI

public struct EntryPoint: View {
    public init() {
        UITabBar.appearance().isHidden = true
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithTransparentBackground()
        navigationBarAppearance.backgroundColor = .white
        navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(Color.b_Primary)]
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor(Color.b_Primary)]
        navigationBarAppearance.shadowColor = UIColor(Color.b_ShadowLight)
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        UINavigationBar.appearance().tintColor = UIColor(Color.b_Primary)
    }
    
    public var body: some View {
        EnvironmentConfiguratorView {
            AuthResolverScreenView()
        }
        .accentColor(.b_Primary)
        .foregroundColor(.b_TextBlack)
        .background(Color.white)
        .progressViewStyle(CustomProgressViewStyle())
        .configureWindow()
    }
}

private extension View {
    func configureWindow() -> some View {
        self.background(HostingWindowConfigurator())
    }
}

private struct HostingWindowConfigurator: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        #if targetEnvironment(macCatalyst)
        DispatchQueue.main.async {
            let window = view.window
            window?.windowScene?.titlebar?.titleVisibility = .hidden
            window?.windowScene?.titlebar?.toolbar?.isVisible = false
            window?.windowScene?.titlebar?.separatorStyle = .none
        }
        #endif
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
    }
}
