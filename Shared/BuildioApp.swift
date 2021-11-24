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
    
    init() {
        UITabBar.appearance().isHidden = true
        UINavigationBar.appearance().backgroundColor = .white
//        UINavigationBar.appearance().isTranslucent = true
//        UINavigationBar.appearance().isOpaque = true
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.b_Primary)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.b_Primary)]
//        UINavigationBar.appearance().standardAppearance.configureWithTransparentBackground()
//        UINavigationBar.appearance().compactAppearance = UINavigationBar.appearance().standardAppearance.copy()
    }
    
    var body: some Scene {
        WindowGroup("Buildio") {
            MainCoordinatorView()
                .accentColor(.b_TextBlack)
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
