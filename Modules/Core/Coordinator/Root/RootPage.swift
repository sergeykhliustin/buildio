//
//  RootPage.swift
//  Modules
//
//  Created by Sergii Khliustin on 03.11.2024.
//

import Foundation
import SwiftUI
import FlowStacks
import Dependencies
import Inject

struct RootPage: View {
    @Environment(\.theme) private var theme
    @ObservedObject var viewModel: RootPageModel
    @ObserveInjection var inject

    var body: some View {
        VStack {
            if viewModel.shouldSplit {
                HStack(spacing: 0) {
                    FlowStack(
                        $viewModel.path.primary,
                        withNavigation: true
                    ) {
                        setupDestinations {
                            viewModel.root
                                .view(viewModel: viewModel.viewModel(for: viewModel.root))
                                .enableInjection()
                        }
                        .background(theme.background.color)
                    }
                    .frame(maxWidth: 320)
                    Rectangle()
                        .fill(theme.separatorColor.color)
                        .frame(width: 1)
                    FlowStack(
                        $viewModel.path.secondary,
                        withNavigation: true
                    ) {
                        setupDestinations {
                            Color.clear
                        }
                        .background(theme.background.color)
                    }
                }
            } else {
                FlowStack(
                    $viewModel.path.primary,
                    withNavigation: true
                ) {
                    setupDestinations {
                        viewModel.root
                            .view(viewModel: viewModel.viewModel(for: viewModel.root))
                            .enableInjection()
                    }
                    .background(theme.background.color)
                }
                .background(theme.background.color)
            }
        }
        .animation(.easeInOut, value: viewModel.path.secondary)
        .background(theme.background.color)
        .enableInjection()
    }

    @ViewBuilder
    private func setupDestinations(@ViewBuilder content: () -> some View) -> some View {
        content()
            #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
            #endif
            .flowDestination(for: RouteType.self) { path in
                path.view(viewModel: viewModel.viewModel(for: path))
                    #if os(iOS)
                    .navigationBarTitleDisplayMode(.large)
                    #endif
                    .toolbar {
                        if path.style == .sheet {
                            ToolbarItemGroup(placement: .topBarTrailing) {
                                Image(.xmark)
                                    .button {
                                        viewModel.dismiss()
                                    }
                            }
                        }
                    }
                    .background(theme.background.color)
                    .enableInjection()
            }
    }
}
