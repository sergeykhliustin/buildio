//
//  SwiftUIView.swift
//  
//
//  Created by Sergey Khliustin on 26.11.2021.
//

import SwiftUI
import BitriseAPIs

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
        .introspectViewController { controller in
            #if targetEnvironment(macCatalyst)
            let window = controller.viewIfLoaded?.window
            window?.windowScene?.titlebar?.titleVisibility = .hidden
            window?.windowScene?.titlebar?.toolbar?.isVisible = false
            window?.windowScene?.titlebar?.separatorStyle = .none
            #endif
        }
    }
}

struct EntryPoint_Previews: PreviewProvider {
    static var previews: some View {
        EntryPoint()
    }
}
