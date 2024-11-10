//
//  AbortBuildPage.swift
//  Modules
//
//  Created by Sergii Khliustin on 07.11.2024.
//

import Foundation
import SwiftUI
import UITypes
import Components
import Dependencies

package struct AbortBuildPage: PageType {
    @ObservedObject package var viewModel: AbortBuildPageModel
    @State private var height: CGFloat = 0

    package init(viewModel: AbortBuildPageModel) {
        self.viewModel = viewModel
    }

    package var content: some View {
        VStack {
            HStack {
                if viewModel.isLoading {
                    BuildioProgressView()
                }
                Spacer()
                Image(.xmark)
                    .padding()
                    .button {
                        viewModel.dependencies.navigator.dismiss()
                    }
            }
            ListItem {
                BuildRowView(model: viewModel.build, isLoading: false)
            }
            .fixedSize(horizontal: false, vertical: true)
            .id(viewModel.build.id)
            Text("Are you sure you want to abort this build?")
                .font(.body)
            Text("You can specify a reason below for aborting this build.")
                .font(.caption)
            BuildioTextField(
                text: $viewModel.reason,
                placeholder: "Abort reason (optional)",
                canClear: true
            )
            AbortButton {
                viewModel.onAbort()
            }
            Spacer()
        }
        .overlay(
            GeometryReader { proxy in
                Color.clear
                    .preference(key: InnerHeightPreferenceKey.self, value: proxy.size.height)
            }
        )
        .onPreferenceChange(InnerHeightPreferenceKey.self) {
            height = $0
        }
        .multilineTextAlignment(.center)
        .padding(.horizontal, 16)
        .disabled(viewModel.isLoading)
        .presentationDetents([.height(height)])
    }
}

private struct InnerHeightPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    AbortBuildPage(
        viewModel: AbortBuildPageModel(
            dependencies: DependenciesMock(),
            build: .preview()
        )
    )
}
