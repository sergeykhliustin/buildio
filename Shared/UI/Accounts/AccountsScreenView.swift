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
                    ListItemWrapper(cornerRadius: 4) {
                        tokenManager.token = token
                    } content: {
                        HStack {
                            Text(token.email)
                            Spacer()
                            if token.current {
                                Image(systemName: "checkmark")
                            }
                            Button {
                                logger.debug("trash")
                                tokenManager.remove(token)
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                        .padding(16)
                        .border(Color.b_BorderLight, width: 1)
                        .cornerRadius(4)
                    }
                }
            }
            .padding(.horizontal, 16)
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
