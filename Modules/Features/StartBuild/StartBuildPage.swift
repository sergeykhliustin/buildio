//
//  StartBuildPage.swift
//  Modules
//
//  Created by Sergii Khliustin on 07.11.2024.
//

import Foundation
import SwiftUI
import UITypes
import Components
import Dependencies

package struct StartBuildPage: PageType {
    @Environment(\.theme) private var theme
    @ObservedObject package var viewModel: StartBuildPageModel

    package init(viewModel: StartBuildPageModel) {
        self.viewModel = viewModel
    }

    package var content: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                Text("App:")
                BuildioTextField(
                    text: .constant(viewModel.app?.title ?? ""),
                    placeholder: "Select the app",
                    trailing: {
                        Image(.chevron_right)
                            .padding(.horizontal, 8)
                    })
                    .disabled(true)
                    .button {
                        viewModel.onAppSelect()
                    }
                    .listShadow(theme)

                Text("Branch:")
                BuildioTextField(
                    text: $viewModel.params.branch,
                    placeholder: "Select branch",
                    trailing: {
                        Image(.chevron_right)
                            .padding(.horizontal, 8)
                            .button {
                                viewModel.onBranchSelect()
                            }
                    })
                    .disabled(viewModel.app == nil)
                    .listShadow(theme)

                Text("Workflow:")
                BuildioTextField(
                    text: $viewModel.params.workflow,
                    placeholder: "Select workflow",
                    trailing: {
                        Image(.chevron_right)
                            .padding(.horizontal, 8)
                            .button {
                                viewModel.onWorkflowSelect()
                            }
                    })
                    .disabled(viewModel.app == nil)
                    .listShadow(theme)
                Text("Message:")
                BuildioTextField(
                    text: $viewModel.params.message,
                    placeholder: "e.g. triggered by Buildio"
                )
                .disabled(viewModel.app == nil)
                .listShadow(theme)

                StartBuildButton("Start") {
                    viewModel.onStartBuild()
                }
                .disabled(!viewModel.params.isValid)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(16)
        }
        .disabled(viewModel.isLoading)
        .navigationBarTitle("Start build")
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                if viewModel.isLoading {
                    BuildioProgressView()
                }
            }
        }
    }
}

#Preview {
    StartBuildPage(viewModel: StartBuildPageModel(dependencies: DependenciesMock(), app: nil))
}
