//
//  SwiftUIView.swift
//  
//
//  Created by Sergey Khliustin on 26.11.2021.
//

import SwiftUI
import BitriseAPIs

public struct EntryPoint: View {
    public init() {
        BaseAPI.defaultApiToken = { TokenManager.shared.token?.token }
        BackgroundProcessing.shared.start()
        ViewModelResolver.start()
    }
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

struct EntryPoint_Previews: PreviewProvider {
    static var previews: some View {
        EntryPoint()
    }
}
