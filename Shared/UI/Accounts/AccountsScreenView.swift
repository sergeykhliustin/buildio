//
//  AccountsScreenView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 05.10.2021.
//

import SwiftUI

struct AccountsScreenView: View {
    @State private var showingSheet = false
    @StateObject private var tokenManager = TokenManager.shared
    
    var body: some View {
        
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(tokenManager.tokens, id: \.token) { token in
                    ListItemWrapper {
                        tokenManager.token = token
                    } content: {
                        AccountRowView(token)
                    }
                }
            }
        }
        .toolbar {
            Button {
                showingSheet.toggle()
            } label: {
                Image(systemName: "plus")
            }
            .sheet(isPresented: $showingSheet) {
                TokenFigmaScreenView(canClose: true) {
                    showingSheet = false
                }
            }
        }
        
    }
}

struct AccountsScreenView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsScreenView()
    }
}
