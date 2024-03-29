//
//  AccountsScreenView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 05.10.2021.
//

import SwiftUI
import BuildioLogic

struct AccountsScreenView: View {
    @EnvironmentObject private var navigator: Navigator
    @Environment(\.theme) var theme
    @EnvironmentObject private var navigators: Navigators
    @EnvironmentObject private var tokenManager: TokenManager
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(tokenManager.tokens) { token in
                    ListItemWrapper {
                        navigators.popToRootAll()
                        tokenManager.token = token
                        navigators.tabSelection = 0
                    } content: {
                        AccountRowView(token, settings: {
                            navigator.go(.accountSettings(token), replace: true)
                        })
                    }
                    .defaultHorizontalPadding()
                }
            }
            .padding(.top, 16)
        }
        .toolbar {
            if tokenManager.token?.isDemo == false {
                Button {
                    navigator.go(.auth({
                        navigator.dismiss()
                        navigators.popToRootAll()
                    }))
                } label: {
                    Image(.plus)
                }
                .foregroundColor(theme.accentColor)
            }
        }
    }
}

struct AccountsScreenView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsScreenView()
    }
}
