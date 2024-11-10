//
//  ActivitiesPage.swift
//  Modules
//
//  Created by Sergii Khliustin on 05.11.2024.
//

import SwiftUI
import Models
import UITypes
import Components

package struct ActivitiesPage: PageType {
    @ObservedObject package var viewModel: ActivitiesPageModel

    package init(viewModel: ActivitiesPageModel) {
        self.viewModel = viewModel
    }

    package var content: some View {
        BuildioList {
            if viewModel.notificationsAuthorization != .authorized {
                NavigateSettingsItem(title: "Enable notifications", icon: .bell) {
                    viewModel.onNotifications()
                }
            }
            if let items = viewModel.data?.data {
                ForEach(items) { item in
                    ListItem(
                        action: {
                            viewModel.onActivity(item)
                        },
                        content: {
                            ActivityRowView(
                                model: item
                            )
                        }
                    )
                }
                if viewModel.canLoadMore {
                    BuildioProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .onAppear {
                            viewModel.loadMore()
                        }
                }
            }
        }
        .refreshable {
            viewModel.refresh()
        }
        .navigationTitle("Activities")
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                if viewModel.isLoading {
                    BuildioProgressView()
                }
            }
        }
    }
}
