//
//  AccountsScreenView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 05.10.2021.
//

import SwiftUI
import SwiftUINavigation

struct AccountsScreenView: ScreenBuilder {
    @Environment(\.isDemoMode) var isDemoMode
    @Environment(\.theme) var theme
    @EnvironmentObject private var navigators: Navigators
    @State private var showingSheet = false
    @StateObject private var tokenManager = TokenManager.shared
    
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
            if !isDemoMode.wrappedValue {
                Button {
                    showingSheet.toggle()
                } label: {
                    Image(systemName: "plus")
                }
                .foregroundColor(theme.accentColor)
            }
        }
        .sheet(isPresented: $showingSheet) {
            authScreen(canClose: true) {
                showingSheet = false
            }
        }
        
    }
}

struct AccountsScreenView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsScreenView()
    }
}
