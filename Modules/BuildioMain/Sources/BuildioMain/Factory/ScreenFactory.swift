//
//  ScreenFactory.swift
//  
//
//  Created by Sergey Khliustin on 18.01.2022.
//

import Foundation
import SwiftUI
import Models

@MainActor
final class ScreenFactory: ObservableObject {
    private let viewModelFactory: ViewModelFactory
    
    init(_ viewModelFactory: ViewModelFactory) {
        self.viewModelFactory = viewModelFactory
    }
    
    // MARK: - Builds
    @ViewBuilder
    func buildsScreen(app: V0AppResponseItemModel? = nil) -> some View {
        BuildsScreenView()
            .environmentObject(viewModelFactory.builds(app: app))
            .navigationTitle(app?.title ?? "Builds")
    }
    
    @ViewBuilder
    func buildRowView(build: BuildResponseItemModel, showBottomControls: Bool) -> some View {
        BuildRowView(build: build, showBottomControls: showBottomControls)
            .environmentObject(viewModelFactory.build(build))
    }
    
    @ViewBuilder
    func buildScreen(build: BuildResponseItemModel) -> some View {
        BuildScreenView()
            .environmentObject(viewModelFactory.build(build))
            .navigationTitle("Build #\(String(build.buildNumber))")
    }
    
    @ViewBuilder
    func logsScreen(build: BuildResponseItemModel) -> some View {
        LogsScreenView(build: build)
            .environmentObject(viewModelFactory.logs(build))
            .navigationTitle("Build #\(String(build.buildNumber)) logs")
    }
    
    @ViewBuilder
    func artifactsScreen(build: BuildResponseItemModel) -> some View {
        ArtifactsScreenView()
            .environmentObject(viewModelFactory.artifacts(build))
            .navigationTitle("Build #\(String(build.buildNumber)) artifacts")
    }
    
    // MARK: - New Build
    
    @ViewBuilder
    func newBuildScreen(app: V0AppResponseItemModel? = nil) -> some View {
        NewBuildScreenView(app: app)
            .environmentObject(viewModelFactory.newBuild())
            .navigationTitle("Start a build")
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
    
    @ViewBuilder
    func appsScreen() -> some View {
        AppsScreenView()
            .environmentObject(viewModelFactory.resolve(AppsViewModel.self))
            .navigationTitle("Apps")
    }
    
    @ViewBuilder
    func appSelectScreen(completion: @escaping ((V0AppResponseItemModel) -> Void)) -> some View {
        AppsScreenView(completion: completion)
            .environmentObject(viewModelFactory.resolve(AppsViewModel.self))
            .navigationTitle("Select the app")
    }
    
    // MARK: - Activities
    
    @ViewBuilder
    func activitiesScreen() -> some View {
        ActivitiesScreenView()
            .environmentObject(viewModelFactory.resolve(ActivitiesViewModel.self))
            .navigationTitle("Activities")
    }
    
    // MARK: - Accounts
    
    @ViewBuilder
    func accountsScreen() -> some View {
        AccountsScreenView()
            .navigationTitle("Accounts")
    }
    
    @ViewBuilder
    func authScreen(canClose: Bool = false, onCompletion: (() -> Void)? = nil) -> some View {
        AuthScreenView(canClose: canClose, onCompletion: onCompletion)
    }
    
    @ViewBuilder
    func getToken() -> some View {
        AuthWebViewContoller()
            .navigationTitle(AuthWebViewContoller.navigationTitle)
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
    
    @ViewBuilder
    func settingsScreen() -> some View {
        SettingsScreenView()
    }
    
    @ViewBuilder
    func aboutScreen() -> some View {
        AboutScreenView()
    }
    
    // MARK: - Debug
    
    @ViewBuilder
    func debugScreen() -> some View {
        DebugScreenView()
    }
    
    @ViewBuilder
    func debugLogsScreen() -> some View {
        DebugLogsScreenView()
    }
    
    @ViewBuilder
    func themeScreen(theme: Theme) -> some View {
        ThemeConfiguratorScreenView(themeToTune: theme)
    }
}
