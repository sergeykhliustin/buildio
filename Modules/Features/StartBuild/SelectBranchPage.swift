//
//  SelectBranchPage.swift
//  Modules
//
//  Created by Sergii Khliustin on 07.11.2024.
//

import Foundation
import SwiftUI
import UITypes

package struct SelectBranchPage: PageType {
    @ObservedObject package var viewModel: SelectBranchPageModel

    package init(viewModel: SelectBranchPageModel) {
        self.viewModel = viewModel
    }

    package var content: some View {
        SelectBaseView(
            data: viewModel.data,
            onRefresh: {
                viewModel.refresh()
            },
            onSelect: {
                viewModel.onSelectBranch($0)
            }
        )
        .navigationTitle("Select Branch")
    }
}
