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
