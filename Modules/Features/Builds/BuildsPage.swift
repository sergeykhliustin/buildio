//
//  BuildsScreenView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 01.10.2021.
//

import SwiftUI
import Models
import UITypes
import Components

package struct BuildsPage: PageType {
    @Environment(\.theme) var theme
    @ObservedObject package var viewModel: BuildsPageModel

    package init(viewModel: BuildsPageModel) {
        self.viewModel = viewModel
    }

    package var content: some View {
        BuildioList {
            if let items = viewModel.data?.data {
                ForEach(items) { item in
                    ListItem(
                        action: {
                            viewModel.onBuild(item)
                        },
                        content: {
                            BuildRowView(
                                model: item,
                                isLoading: item.id == viewModel.loadingBuildId
                            )
                        }
                    )
                    .contextMenu {
                        Button(
                            action: {
                                viewModel.dependencies.navigator.show(.logs(item))
                            },
                            label: {
                                Image(.note_text)
                                Text("Logs")
                            }
                        )

                        if item.status == .running {
                            Button(
                                action: {
                                    viewModel.dependencies.navigator.show(.abortBuild(item))
                                },
                                label: {
                                    Image(.nosign)
                                    Text("Abort")
                                }
                            )
                        } else {
                            Button(
                                action: {
                                    viewModel.dependencies.navigator.show(.artifacts(item))
                                },
                                label: {
                                    Image(.archivebox)
                                    Text("Artifacts")
                                }
                            )

                            HStack {
                                Image(.hammer)
                                Text("Rebuild")
                            }
                            .button {
                                viewModel.onRebuild(item)
                            }
                        }
                    }
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
        .navigationTitle(viewModel.app?.title ?? "Builds")
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                HStack(spacing: 20) {
                    if viewModel.isLoading {
                        BuildioProgressView()
                    }

                    if viewModel.app == nil {
                        Image(.bell)
                            .button {
                                viewModel.dependencies.navigator.show(.activities)
                            }
                    }

                    Image(.plus)
                        .button {
                            viewModel.dependencies.navigator.show(.startBuild(app: viewModel.app))
                        }
                }
            }
        }
    }
}
