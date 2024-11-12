//
//  WebFlowPage.swift
//  Modules
//
//  Created by Sergii Khliustin on 12.11.2024.
//

import Foundation
import SwiftUI
import UITypes
import Dependencies

package struct WebFlowPage: PageType {
    @ObservedObject package var viewModel: WebFlowPageModel

    package init(viewModel: WebFlowPageModel) {
        self.viewModel = viewModel
    }

    package var content: some View {
        VStack(spacing: 0) {
            if viewModel.progress < 1.0 && viewModel.progress > 0.0 {
                ProgressView(value: viewModel.progress)
                    .progressViewStyle(LinearProgressViewStyle())
            }
            InternalWebView(
                url: viewModel.url,
                progress: $viewModel.progress,
                title: .constant("")
            )
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Image(.safari)
                    .button {
                        viewModel.onExternalBrowser()
                    }
            }
        }
    }
}

#Preview {
    WebFlowPage(viewModel: WebFlowPageModel(dependencies: DependenciesMock(), url: URL(string: "https://google.com")!))
}
