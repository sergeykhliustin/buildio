//
//  BuildScreenView.swift
//  Modules
//
//  Created by Sergii Khliustin on 05.11.2024.
//

import Foundation
import SwiftUI
import UITypes
import Components

package struct BuildPage: PageType {
    @Environment(\.theme) var theme
    @ObservedObject package var viewModel: BuildPageModel

    package init(viewModel: BuildPageModel) {
        self.viewModel = viewModel
    }

    package var content: some View {
        ScrollView {
            VStack {
                if viewModel.build.status == .running {
                    AbortButton {
                        viewModel.onAbort()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    StartBuildButton("Rebuild") {
                        viewModel.onRebuild()
                    }
                }

                NavigateSettingsItem(title: "Logs", icon: .note_text) {
                    viewModel.dependencies.navigator.show(.logs(viewModel.build))
                }
                if viewModel.build.status != .running {
                    NavigateSettingsItem(title: "Apps & Artifacts", icon: .archivebox) {
                        viewModel.dependencies.navigator.show(.artifacts(viewModel.build))
                    }
                }

                NavigateSettingsItem(title: "Bitrise.yml", icon: .gearshape_2) {
                    viewModel.dependencies.navigator.show(.yml(viewModel.build))
                }

                ListItem {
                    BuildView(build: viewModel.build, messageStyle: $viewModel.messageStyle)
                        .id(viewModel.build.id)
                }
                .id(viewModel.build.id)
            }
            .padding(.horizontal, 16)
        }
        .navigationTitle("Build #\(String(viewModel.build.buildNumber))")
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                if viewModel.isLoading {
                    BuildioProgressView()
                }
            }
        }
    }
}
