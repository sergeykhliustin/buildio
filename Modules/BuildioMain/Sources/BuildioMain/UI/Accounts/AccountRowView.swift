//
//  AccountRowView.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 05.11.2021.
//

import SwiftUI
import Models
import Combine
import BitriseAPIs

private final class AccountRowViewModel: BaseViewModel<V0UserProfileDataModel> {
    let token: String
    
    init(token: String) {
        self.token = token
        super.init()
    }
    
    override func fetch() -> AnyPublisher<V0UserProfileDataModel, ErrorResponse> {
        UserAPI(apiToken: token)
            .userProfile().map({ $0.data })
            .eraseToAnyPublisher()
    }
}

struct AccountRowView: View {
    @Environment(\.isDemoMode) private var isDemoMode
    @StateObject private var model: AccountRowViewModel
    @StateObject private var tokenManager = TokenManager.shared
    let token: Token
    
    init(_ token: Token) {
        self.token = token
        self._model = StateObject(wrappedValue: AccountRowViewModel(token: token.token))
    }
    
    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 8) {
                if let user = model.value {
                    AvatarView(user: user)
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
                        AvatarView(title: token.token)
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
                        isDemoMode.wrappedValue = false
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
