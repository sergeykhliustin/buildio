//
//  CoordinatorPage.swift
//  Modules
//
//  Created by Sergii Khliustin on 31.10.2024.
//

import Foundation
import SwiftUI
import FlowStacks
import Auth
import Inject
import SwiftUIIntrospect
import Components
import Logger
import UITypes
import Dependencies

public struct CoordinatorPage: View {
    @Environment(\.theme) private var theme
    @Environment(\.horizontalSizeClass) var originalSizeClass
    @StateObject private var viewModel: CoordinatorPageModel
    @ObserveInjection var inject
    @AppStorageCodable(Settings.key) var settings = Settings()

    public init(viewModel: CoordinatorPageModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        Group {
            if viewModel.isLoading {
                BuildioProgressView()
            } else if let authPageModel = viewModel.authPageModel {
                RootPage(viewModel: authPageModel)
            } else {
                HStack(spacing: 0) {
                    if viewModel.windowMode == .split {
                        BuildioTabBar(
                            tabs: viewModel.tabs,
                            style: .vertical,
                            selected: $viewModel.tab,
                            onSecondTap: {
                                viewModel.popToRoot(tab: $0)
                            }
                        )
                    }
                    VStack(spacing: 0) {
                        BuildioTabView(tabs: viewModel.tabs, tab: $viewModel.tab) { tab in
                            RootPage(viewModel: viewModel.rootPageModel(tab: tab))
                        }
                        if viewModel.windowMode == .compact {
                            BuildioTabBar(
                                tabs: viewModel.tabs,
                                style: .horizontal,
                                selected: $viewModel.tab,
                                onSecondTap: {
                                    viewModel.popToRoot(tab: $0)
                                }
                            )
                        }
                    }
                }
                .overlay(
                    GeometryReader { geometry in
                        Color.clear.preference(
                            key: InnerWidthPreferenceKey.self,
                            value: geometry.size.width
                        )
                    }
                )
                .onPreferenceChange(InnerWidthPreferenceKey.self) { width in
                    if width > 700 {
                        viewModel.windowMode = .split
                    } else {
                        viewModel.windowMode = .compact
                    }
                }
            }
        }
        .background(theme.background.color)
        .modifier(Introspector())
        .tint(theme.accentColor.color)
        .preferredColorScheme(settings.preferredColorScheme)
        .id(viewModel.id)
        .enableInjection()
    }
}

private struct InnerWidthPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    CoordinatorPage(viewModel: CoordinatorPageModel())
}
