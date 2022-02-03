//
//  AccountRowView.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 05.11.2021.
//

import SwiftUI
import Models
import BuildioLogic

struct AccountRowView: View {
    @EnvironmentObject private var screenFactory: ScreenFactory
    @EnvironmentObject private var tokenManager: TokenManager
    
    @StateObject private var model: AccountRowViewModel
    
    let token: Token
    
    init(_ token: Token) {
        self.token = token
        self._model = StateObject(wrappedValue: AccountRowViewModel(token: token))
    }
    
    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 8) {
                if let user = model.value {
                    screenFactory
                        .avatartView(user: user)
                        .frame(width: 40, height: 40)
                        .cornerRadius(8)
                    VStack(alignment: .leading) {
                        if let username = user.username {
                            Text(username)
                                .font(.footnote.bold())
                        }
                        Text(user.email)
                    }
                } else {
                    if case .loading = model.state {
                        ProgressView()
                            .frame(width: 40, height: 40)
                    } else {
                        screenFactory
                            .avatarView(title: token.email)
                            .frame(width: 40, height: 40)
                            .cornerRadius(8)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(token.email)
                        if let error = model.errorString {
                            Text(error)
                                .font(.footnote.bold())
                                .foregroundColor(.red)
                        }
                    }
                }
                Spacer()
                if token == tokenManager.token {
                    Image(systemName: "checkmark")
                }
                Button {
                    logger.debug("trash")
                    if token.isDemo {
                        tokenManager.exitDemo()
                    } else {
                        tokenManager.remove(token)
                    }
                } label: {
                    Image(systemName: "trash")
                }
            }
            .padding(.horizontal, 8)
            .frame(minHeight: 40)
        }
        .onAppear { model.refresh() }
        .font(.footnote)
        .padding(.vertical, 8)
    }
}

struct AccountRowView_Previews: PreviewProvider {
    static var previews: some View {
        AccountRowView(Token(token: "asdas", email: "email"))
    }
}
