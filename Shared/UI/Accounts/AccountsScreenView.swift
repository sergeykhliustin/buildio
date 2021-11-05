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
            LazyVStack {
                ForEach(tokenManager.tokens, id: \.token) { token in
                    ListItemWrapper {
                        tokenManager.token = token
                    } content: {
                        AccountRowView(token)
                    }
                }
            }
//            .padding(.horizontal, 16)
        }
        .toolbar {
            Button {
                showingSheet.toggle()
            } label: {
                Image(systemName: "plus.circle")
                    .imageScale(.large)
            }
            .padding()
            .sheet(isPresented: $showingSheet) {
                TokenFigmaScreenView {
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
