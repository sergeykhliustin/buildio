//
//  AuthResolverScreenView.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 25.11.2021.
//

import SwiftUI
import BuildioLogic

public struct AuthResolverScreenView: View {
    @EnvironmentObject private var navigators: Navigators
    @EnvironmentObject private var screenFactory: ScreenFactory
    @EnvironmentObject private var tokenManager: TokenManager
    
    public init() { }
    
    public var body: some View {
        if tokenManager.token == nil {
            SplitNavigationView(shouldSplit: false) {
                screenFactory
                    .authScreen(canClose: false, onCompletion: nil)
            }
            .ignoresSafeArea()
            .environmentObject(navigators.navigator(for: .auth))
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
