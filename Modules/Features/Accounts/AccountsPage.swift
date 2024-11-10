//
//  AccountsPage.swift
//  Modules
//
//  Created by Sergii Khliustin on 05.11.2024.
//

import SwiftUI
import UITypes
import Components

package struct AccountsPage: PageType {
    @ObservedObject package var viewModel: AccountsPageModel

    package init(viewModel: AccountsPageModel) {
        self.viewModel = viewModel
    }

    package var content: some View {
        BuildioList {
            ForEach(viewModel.tokens) { token in
                ListItem(
                    action: {
                        viewModel.onSelect(token)
                    },
                    content: {
                        AccountRowView(
                            token: token,
                            profile: viewModel.profiles[token],
                            isSelected: token == viewModel.token,
                            onRemove: {/* viewModel.onRemove(token)*/ }
                        )
                    }
                )
            }
        }
        .refreshable {
            viewModel.refresh()
        }
        .navigationTitle("Accounts")
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                if viewModel.isLoading {
                    BuildioProgressView()
                }
                Image(.plus)
                    .button {
                        viewModel.dependencies.navigator.show(.auth)
                    }
            }
        }
    }
}
