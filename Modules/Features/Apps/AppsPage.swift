import Foundation
import SwiftUI
import UITypes
import Components

package struct AppsPage: PageType {
    @ObservedObject package var viewModel: AppsPageModel
    @Environment(\.theme) var theme
    @FocusState private var isFocused: Bool

    package init(viewModel: AppsPageModel) {
        self.viewModel = viewModel
    }

    package var content: some View {
        BuildioList {
            Section {
                if let items = viewModel.response?.data {
                    ForEach(items) { item in
                        ListItem(
                            action: {
                                viewModel.onApp(item)
                            },
                            content: {
                                AppRowView(
                                    model: item,
                                    isMuted: viewModel.isMuted(item),
                                    onMuteToggle: {
                                        viewModel.toggleMuted(item)
                                    }
                                )
                            }
                        )
                    }
                }
            } header: {
                searchBar.id("Apps_SearchBar")
            }
            .background(theme.background.color)
        }
        .id(viewModel.id)
        .background(theme.background.color)
        .refreshable {
            viewModel.refresh()
        }
        .navigationTitle("Apps")
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                if viewModel.isLoading {
                    BuildioProgressView()
                }
            }
        }
    }

    @ViewBuilder
    private var searchBar: some View {
        BuildioTextField(text: $viewModel.query, placeholder: "Search", canClear: true)
            .focused($isFocused)
            .listRowInsets(EdgeInsets())
            .background(theme.background.color)
            .listShadow(theme)
    }
}
