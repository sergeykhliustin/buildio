//
//  SelectWorkflowPage.swift
//  Modules
//
//  Created by Sergii Khliustin on 07.11.2024.
//

import Foundation
import SwiftUI
import UITypes

package struct SelectWorkflowPage: PageType {
    @ObservedObject package var viewModel: SelectWorkflowPageModel

    package init(viewModel: SelectWorkflowPageModel) {
        self.viewModel = viewModel
    }

    package var content: some View {
        SelectBaseView(
            data: viewModel.data,
            onRefresh: {
                viewModel.refresh()
            },
            onSelect: {
                viewModel.onSelectWorkflow($0)
            }
        )
        .navigationTitle("Select Branch")
    }
}
