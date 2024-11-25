//
//  BuildLogPage.swift
//  Modules
//
//  Created by Sergii Khliustin on 06.11.2024.
//

import Foundation
import SwiftUI
import UITypes
import Components

package struct BuildLogPage: PageType {
    @ObservedObject package var viewModel: BuildLogPageModel
    package init(viewModel: BuildLogPageModel) {
        self.viewModel = viewModel
    }

    package var content: some View {
        LogsView(logs: viewModel.attributedLogs, canFetchFullLog: viewModel.canFetchFullLog, fetchFullLogAction: viewModel.onFetchFullLog)
            .navigationTitle("Build #\(String(viewModel.build.buildNumber)) logs")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    if viewModel.isLoading {
                        BuildioProgressView()
                    }
                    Image(.square_and_arrow_up)
                        .button(action: viewModel.onShareRawLog)
                }
            }
    }
}
