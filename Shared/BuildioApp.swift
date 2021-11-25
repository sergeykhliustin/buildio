//
//  BuildioApp.swift
//  Shared
//
//  Created by Sergey Khliustin on 01.10.2021.
//

import SwiftUI
import UIKit

@main
struct BuildioApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var fullscreen: Bool = false
    
    init() {
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
    
    var body: some Scene {
        WindowGroup("Buildio") {
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
