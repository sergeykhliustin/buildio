//
//  SwiftUIView.swift
//  
//
//  Created by Sergey Khliustin on 26.11.2021.
//

import SwiftUI
import BuildioLogic

public struct EntryPoint: View {
    private let previewMode: Bool
    private let theme: Binding<Theme>?
    
    public init(previewMode: Bool = false, theme: Binding<Theme>? = nil) {
        self.previewMode = previewMode
        self.theme = theme
    }
    public var body: some View {
        EnvironmentConfiguratorView(previewMode: previewMode) {
            AppThemeConfiguratorView(forcedTheme: theme) {
                AuthResolverScreenView()
            }
        }
        .statusBar(hidden: ProcessInfo.processInfo.isTestEnv)
        .withHostingWindow { window in
            if ProcessInfo.processInfo.isTestEnv {
                UIView.setAnimationsEnabled(false)
                window?.layer.speed = 100
            }
            #if targetEnvironment(macCatalyst)
            let titlebar = window?.windowScene?.titlebar
            titlebar?.titleVisibility = .hidden
            titlebar?.toolbar?.isVisible = false
            titlebar?.separatorStyle = .none
            #endif
        }

    }
}

extension View {
    func withHostingWindow(_ callback: @escaping (UIWindow?) -> Void) -> some View {
        self.background(HostingWindowFinder(callback: callback))
    }
}

struct HostingWindowFinder: UIViewRepresentable {
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

struct EntryPoint_Previews: PreviewProvider {
    static var previews: some View {
        EntryPoint()
    }
}
