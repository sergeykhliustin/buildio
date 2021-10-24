//
//  AccountsScreenView.swift
//  Buildio
//
//  Created by severehed on 05.10.2021.
//

import SwiftUI

struct AccountsScreenView: View {
    @State private var showingSheet = false
    @StateObject private var tokenManager = TokenManager.shared
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
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
            
            ScrollView {
                LazyVStack {
                    ForEach(tokenManager.tokens, id: \.self) { token in
                        Button {
                            tokenManager.setToken(token)
                        } label: {
                            Text(token)
                            if token == tokenManager.currentToken {
                                Image(systemName: "checkmark")
                            }
                        }
                        .buttonStyle(.plain)
                        
                    }
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
