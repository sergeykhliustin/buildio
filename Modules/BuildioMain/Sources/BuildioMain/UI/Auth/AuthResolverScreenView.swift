//
//  AuthResolverScreenView.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 25.11.2021.
//

import SwiftUI

public struct AuthResolverScreenView: View {
    @StateObject var tokenManager = TokenManager.shared
    
    public init() { }
    
    public var body: some View {
        if tokenManager.token == nil {
            AuthScreenView(canClose: false)
                .introspectViewController { controller in
                    #if targetEnvironment(macCatalyst)
                    controller.viewIfLoaded?.window?.windowScene?.sizeRestrictions?.minimumSize = CGSize(width: 414, height: 600)
                    #endif
                }
        } else {
            RootScreenView()
        }
    }
}

struct AuthResolverScreenView_Previews: PreviewProvider {
    static var previews: some View {
        AuthResolverScreenView()
    }
}
