//
//  AccountsScreenView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 05.10.2021.
//

import SwiftUI
import SwiftUINavigation

struct AccountsScreenView: View {
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
            Button {
                showingSheet.toggle()
            } label: {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $showingSheet) {
            AuthScreenView(canClose: true) {
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
