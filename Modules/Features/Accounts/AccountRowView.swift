//
//  AccountRowView.swift
//  Modules
//
//  Created by Sergii Khliustin on 05.11.2024.
//

import SwiftUI
import Dependencies
import Models
import Components

struct AccountRowView: View {

    let token: Token
    let profile: V0UserProfileDataModel?
    let isSelected: Bool
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 8) {
                if let profile {
                    WebImage(title: profile.username ?? profile.email, url: profile.avatarUrl)
                        .frame(width: 40, height: 40)
                        .rounded()
                    VStack(alignment: .leading) {
                        if let username = profile.username {
                            Text(username)
                                .font(.footnote.bold())
                        }
                        Text(profile.email)
                    }
                } else {
                    WebImage(title: token.email, url: nil)
                        .frame(width: 40, height: 40)
                        .rounded()

                    VStack(alignment: .leading) {
                        Text(token.email)
                    }
                }
                Spacer()
                if isSelected {
                    Image(.checkmark)
                }
                Image(.trash)
                    .padding()
                    .button(action: onRemove)
            }
            .padding(.horizontal, 8)
            .frame(minHeight: 40)
        }
        .font(.footnote)
        .padding(.vertical, 8)
    }
}

#Preview {
    AccountRowView(
        token: Token(token: "asdas", email: "email"),
        profile: nil,
        isSelected: true,
        onRemove: {}
    )
}
