//
//  CoordinatorPageModel.swift
//  Modules
//
//  Created by Sergii Khliustin on 31.10.2024.
//
import SwiftUI
import Combine
import FlowStacks
import Dependencies
import Auth
import Components
import DataProviders
import Logger
import Assets
import UITypes

@MainActor
public final class CoordinatorPageModel: ObservableObject {
    var id: String? {
        tokenManager.token?.id
    }
    let tokenManager = TokenManager()
    private var activityProvider = ActivityProvider(token: nil)
    private var buildStatusProvider = BuildStatusProvider(token: nil)
    let authDependencies: DependenciesType
    @Published var theme = ThemeV2.default
    @Published var isLoading: Bool = true
    @Published var authPageModel: AuthPageModel?
    @Published var tab: BuildioTabItem = .builds
    @Published var tabs: [BuildioTabItem] = [.builds, .apps, .accounts, .activities, .settings]
    @Published var windowMode: WindowMode = .compact {
        didSet {
            rootModels.values.forEach { $0.windowMode = windowMode }
        }
    }
    private var rootModels: [BuildioTabItem: RootPageModel] = [:]

    private var cancellables = Set<AnyCancellable>()

    deinit {
        logger.debug("CoordinatorPageModel deinit")
    }

    public init() {
        self.authDependencies = Dependencies(
            tokenManager: tokenManager,
            navigator: NavigatorMock(),
            activityProvider: activityProvider,
            buildStatusProvider: buildStatusProvider
        )
        updateAppearance()
        tokenManager.$token
            .receive(on: DispatchQueue.main)
            .sink { [weak self] token in
                guard let self else { return }
                Task { @MainActor in
                    if token == nil {
                        self.authPageModel = AuthPageModel(
                            dependencies: self.authDependencies,
                            canDemo: true
                        )
                        self.reset()
                    } else {
                        self.authPageModel = nil
                        self.reset()
                    }
                    isLoading = false
                }
            }
            .store(in: &cancellables)
    }

    private func reset() {
        rootModels.values.forEach { $0.reset() }
        rootModels.removeAll()
        tab = .builds
        activityProvider = ActivityProvider(token: tokenManager.token?.token)
        buildStatusProvider = BuildStatusProvider(token: tokenManager.token?.token)

    }

    func rootPageModel(tab: BuildioTabItem) -> RootPageModel {
        if let model = rootModels[tab] {
            return model
        }
        let model = RootPageModel(
            root: tab.route,
            windowMode: windowMode,
            viewModelFactory: { [unowned self] navigator, path in
                let dependencies = Dependencies(
                    tokenManager: tokenManager,
                    navigator: navigator,
                    activityProvider: activityProvider,
                    buildStatusProvider: buildStatusProvider
                )
                return path.viewModel(dependencies: dependencies)
            }
        )
        rootModels[tab] = model
        return model
    }

    func popToRoot(tab: BuildioTabItem) {
        rootPageModel(tab: tab).dismissAll()
    }

    private func updateAppearance() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        navigationBarAppearance.backgroundColor = theme.background
        navigationBarAppearance.shadowColor = .clear
        navigationBarAppearance.shadowImage = UIImage()
        navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: theme.navigationColor]
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: theme.navigationColor]
        navigationBarAppearance.buttonAppearance.normal.titleTextAttributes = [.foregroundColor: theme.navigationColor]
        navigationBarAppearance.backgroundEffect = nil
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactScrollEdgeAppearance = navigationBarAppearance
        UINavigationBar.appearance().isTranslucent = true
    }
}

extension BuildioTabItem {
    var route: RouteType {
        switch self {
        case .builds:
            return .builds()
        case .apps:
            return .apps
        case .accounts:
            return .accounts
        case .activities:
            return .activities
        case .settings:
            return .settings
        }
    }
}