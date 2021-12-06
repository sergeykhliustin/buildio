//
//  ScreenBuilder.swift
//  
//
//  Created by Sergey Khliustin on 04.12.2021.
//

import Models
import SwiftUI

protocol ScreenBuilder: View {
    
}

extension ScreenBuilder {
    @ViewBuilder
    func buildsScreen(app: V0AppResponseItemModel? = nil) -> some View {
        BuildsScreenView()
            .environmentObject(app == nil ? ViewModelResolver.resolve(BuildsViewModel.self) : BuildsViewModel(app: app))
            .navigationTitle(app?.title ?? "Builds")
    }
    
    @ViewBuilder
    func buildScreen(build: BuildResponseItemModel) -> some View {
        BuildScreenView()
            .environmentObject(BuildViewModel(build: build))
            .navigationTitle("Build #\(String(build.buildNumber))")
    }
    
    @ViewBuilder
    func logsScreen(build: BuildResponseItemModel) -> some View {
        LogsScreenView(build: build)
            .navigationTitle("Build #\(String(build.buildNumber)) logs")
    }
    
    @ViewBuilder
    func artifactsScreen(build: BuildResponseItemModel) -> some View {
        ArtifactsScreenView(build: build)
            .navigationTitle("Build #\(String(build.buildNumber)) artifacts")
    }
    
    @ViewBuilder
    func appsScreen() -> some View {
        AppsScreenView()
            .environmentObject(ViewModelResolver.resolve(AppsViewModel.self))
            .navigationTitle("Apps")
    }
    
    @ViewBuilder
    func appSelectScreen(completion: @escaping ((V0AppResponseItemModel) -> Void)) -> some View {
        AppsScreenView(completion: completion)
            .environmentObject(ViewModelResolver.resolve(AppsViewModel.self))
            .navigationTitle("Select the app")
    }
    
    @ViewBuilder
    func accountsScreen() -> some View {
        AccountsScreenView()
            .navigationTitle("Accounts")
    }
    
    @ViewBuilder
    func activitiesScreen() -> some View {
        ActivitiesScreenView()
            .navigationTitle("Activities")
    }
    
    @ViewBuilder
    func debugScreen() -> some View {
        DebugScreenView()
            .navigationTitle("Debug")
    }
}
