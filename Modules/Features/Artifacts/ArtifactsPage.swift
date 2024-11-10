//
//  ArtifactsPage.swift
//  Modules
//
//  Created by Sergii Khliustin on 10.11.2024.
//

import Foundation
import SwiftUI
import UITypes
import Components

package struct ArtifactsPage: PageType {
    @ObservedObject package var viewModel: ArtifactsPageModel
    @Environment(\.theme) package var theme

    package init(viewModel: ArtifactsPageModel) {
        self.viewModel = viewModel
    }

    package var content: some View {
        BuildioList {
            if let data = viewModel.response?.data, !data.isEmpty {
                ForEach(data) { item in
                    ListItem {
                        ArtifactRowView(value: item)
                    }
                }
            } else if !viewModel.isLoading {
                VStack(spacing: 16) {
                    Image(.hourglass)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40, alignment: .center)
                    Text("Nothing to show")
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .refreshable {
            viewModel.refresh()
        }
        .navigationTitle("Build #\(String(viewModel.build.buildNumber)) artifacts")
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                if viewModel.isLoading {
                    BuildioProgressView()
                }
            }
        }
    }
}
