//
//  ScreenFactory.swift
//  
//
//  Created by Sergey Khliustin on 18.01.2022.
//

import Foundation
import SwiftUI
import Models
import BuildioLogic

protocol Screen {
    associatedtype Content: View
    var title: String { get }
    @ViewBuilder var content: () -> Self.Content { get }
    var hosting: UIHostingController<Self.Content> { get }
}

private struct ScreenItem<Content: View>: Screen {
    var title: String
    var content: () -> Content
    var hosting: UIHostingController<Content> {
        let hosting = UIHostingController(rootView: content())
        hosting.title = title
        return hosting
    }
}

@MainActor
final class ScreenFactory: ObservableObject {
    private let viewModelFactory: ViewModelFactory
    
    init(_ viewModelFactory: ViewModelFactory) {
        self.viewModelFactory = viewModelFactory
    }
    
    // MARK: - Builds
    func buildsScreen(app: V0AppResponseItemModel? = nil) -> some Screen {
        let env = viewModelFactory.builds(app: app)
        return ScreenItem(title: app?.title ?? "Builds") {
            BuildsScreenView()
                .environmentObject(env)
        }
    }
    
    @ViewBuilder
    func buildRowView(build: BuildResponseItemModel) -> some View {
        BuildRowView()
            .environmentObject(viewModelFactory.build(build))
    }

    func buildScreen(build: BuildResponseItemModel) -> some Screen {
        let env = viewModelFactory.build(build)
        return ScreenItem(title: "Build #\(String(build.buildNumber))") {
            BuildScreenView()
                .environmentObject(env)
        }
    }

    func logsScreen(build: BuildResponseItemModel) -> some Screen {
        let env = viewModelFactory.logs(build)
        return ScreenItem(title: "Build #\(String(build.buildNumber)) logs") {
            LogsScreenView(build: build)
                .environmentObject(env)
        }
    }

    func artifactsScreen(build: BuildResponseItemModel) -> some Screen {
        let env = viewModelFactory.artifacts(build)
        return ScreenItem(title: "Build #\(String(build.buildNumber)) artifacts") {
            ArtifactsScreenView()
                .environmentObject(env)
        }
    }

    func ymlScreen(build: BuildResponseItemModel) -> some Screen {
        let env = viewModelFactory.yml(build)
        return ScreenItem(title: "Bitrise.yml") {
            BuildYmlScreenView()
                .environmentObject(env)
        }
    }

    func accountSettings(token: Token) -> some Screen {
        let env = viewModelFactory.accountSettings(token)
        return ScreenItem(title: "Account settings") {
            AccountSettingsScreenView()
                .environmentObject(env)
        }

    }
    
    // MARK: - New Build

    func newBuildScreen(app: V0AppResponseItemModel? = nil) -> some Screen {
        let env = viewModelFactory.newBuild()
        return ScreenItem(title: "Start a build") {
            NewBuildScreenView(app: app)
                .environmentObject(env)
        }
    }

    func branchesScreen(_ branches: [String], onSelect: @escaping (String) -> Void) -> some Screen {
        return ScreenItem(title: "Select branch:") {
            SelectStringScreenView(branches, onSelect: onSelect)
        }
    }

    func workflowsScreen(_ workflows: [String], onSelect: @escaping (String) -> Void) -> some Screen {
        return ScreenItem(title: "Select workflow:") {
            SelectStringScreenView(workflows, onSelect: onSelect)
        }
    }

    @ViewBuilder
    func branchesView(app: V0AppResponseItemModel, branch: Binding<String>) -> some View {
        BranchesView(app: app, branch: branch)
            .environmentObject(viewModelFactory.branches(app: app))
    }

    @ViewBuilder
    func workflowsView(app: V0AppResponseItemModel, workflow: Binding<String>) -> some View {
        WorkflowsView(app: app, workflow: workflow)
            .environmentObject(viewModelFactory.workflows(app: app))
    }
    
    // MARK: - Apps

    func appsScreen() -> some Screen {
        let env = viewModelFactory.resolve(AppsViewModel.self)
        return ScreenItem(title: "Apps") {
            AppsScreenView()
                .environmentObject(env)
        }
    }

    func appSelectScreen(completion: @escaping ((V0AppResponseItemModel) -> Void)) -> some Screen {
        let env = viewModelFactory.resolve(AppsViewModel.self)
        return ScreenItem(title: "Select the app") {
            AppsScreenView(completion: completion)
                .environmentObject(env)
        }
    }
    
    // MARK: - Activities

    func activitiesScreen() -> some Screen {
        let env = viewModelFactory.resolve(ActivitiesViewModel.self)
        return ScreenItem(title: "Activities") {
            ActivitiesScreenView()
                .environmentObject(env)
        }
    }
    
    // MARK: - Accounts

    func accountsScreen() -> some Screen {
        return ScreenItem(title: "Accounts") {
            AccountsScreenView()
        }
    }

    func authScreen(canClose: Bool = false, onCompletion: (() -> Void)? = nil) -> some Screen {
        return ScreenItem(title: "Log in to Bitrise") {
            AuthScreenView(canClose: canClose, onCompletion: onCompletion)
        }
    }

    func getToken() -> some Screen {
        return ScreenItem(title: AuthWebViewContoller.navigationTitle) {
            AuthWebViewContoller()
        }
    }
    
    // MARK: - Avatar
    
    @ViewBuilder
    func avatarView(app: V0AppResponseItemModel) -> some View {
        AvatarView()
            .environmentObject(viewModelFactory.avatar(app: app))
    }
    
    @ViewBuilder
    func avatartView(user: V0UserProfileDataModel) -> some View {
        AvatarView()
            .environmentObject(viewModelFactory.avatar(user: user))
    }
    
    @ViewBuilder
    func avatarView(title: String?, url: String? = nil) -> some View {
        AvatarView()
            .environmentObject(viewModelFactory.avatar(title: title, url: url))
    }
    
    // MARK: - Settings

    func settingsScreen() -> some Screen {
        return ScreenItem(title: "Settings") {
            SettingsScreenView()
        }
    }

    func aboutScreen() -> some Screen {
        return ScreenItem(title: "About") {
            AboutScreenView()
        }
    }

    func colorSchemeScreen() -> some Screen {
        return ScreenItem(title: "Preferred color scheme") {
            ColorSchemeSelectScreenView()
        }
    }

    func themeSelectScreen() -> some Screen {
        return ScreenItem(title: "Preferred theme") {
            ThemeSelectScreenView(colorScheme: .dark)
        }
    }
    
    // MARK: - Debug

    func debugScreen() -> some Screen {
        return ScreenItem(title: "Debug") {
            DebugScreenView()
        }

    }

    func debugLogsScreen() -> some Screen {
        return ScreenItem(title: "Logs") {
            DebugLogsScreenView()
        }
    }

    func themeConfigurationScreen(theme: Theme) -> some Screen {
        return ScreenItem(title: "Theme") {
            ThemeConfiguratorScreenView(themeToTune: theme)
        }
    }
}
