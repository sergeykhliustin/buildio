//
//  SwiftUIView.swift
//  
//
//  Created by Sergey Khliustin on 26.11.2021.
//

import SwiftUI

public struct EntryPoint: View {
    public init() { }
    public var body: some View {
        EnvironmentConfiguratorView {
            AppThemeConfiguratorView {
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
