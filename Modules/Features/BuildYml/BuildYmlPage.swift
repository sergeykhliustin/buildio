//
//  BuildYmlPage.swift
//  Modules
//
//  Created by Sergii Khliustin on 05.11.2024.
//

import Foundation
import SwiftUI
import UITypes
import Components
import Assets

package struct BuildYmlPage: PageType {
    @ObservedObject package var viewModel: BuildYmlPageModel
    @Environment(\.theme) package var theme
    package init(viewModel: BuildYmlPageModel) {
        self.viewModel = viewModel
    }

    package var content: some View {
        BuildioList {
            if let yml = viewModel.yml {
                TextView(yml)
                    .font(.subheadline)
                    .foregroundColor(theme.textColor.color)
                    .padding(16)
            }

        }
        .refreshable {
            viewModel.refresh()
        }
        .navigationTitle("Bitrise.yml")
    }
}
