//
//  AccountsScreenView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 05.10.2021.
//

import SwiftUI

struct AccountsScreenView: View {
    @EnvironmentObject private var navigator: Navigator
    @Environment(\.theme) var theme
    @EnvironmentObject private var navigators: Navigators
    @EnvironmentObject private var tokenManager: TokenManager
    
    var body: some View {
        
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(tokenManager.tokens, id: \.token) { token in
                    ListItemWrapper {
                        navigators.popToRootAll()
                        tokenManager.token = token
                    } content: {
                        AccountRowView(token)
                    }
                }
            }
            .padding(.top, 16)
        }
        .toolbar {
            if tokenManager.token?.isDemo == false {
                Button {
                    navigator.go(.auth({
                        navigator.dismiss()
                    }))
                } label: {
                    Image(systemName: "plus")
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
