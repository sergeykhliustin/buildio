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
    
    var body: some Scene {
        WindowGroup("Buildio") {
            MainCoordinatorView()
                .withHostingWindow { window in
                    window?.windowScene?.titlebar?.titleVisibility = .hidden
                }
        }
    }
}

private extension View {
    func withHostingWindow(_ callback: @escaping (UIWindow?) -> Void) -> some View {
        self.background(HostingWindowFinder(callback: callback))
    }
}

private struct HostingWindowFinder: UIViewRepresentable {
    var callback: (UIWindow?) -> Void

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async { [weak view] in
            self.callback(view?.window)
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
    }
}
