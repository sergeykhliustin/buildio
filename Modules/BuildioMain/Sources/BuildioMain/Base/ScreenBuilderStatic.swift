//
//  File.swift
//  
//
//  Created by Sergey Khliustin on 18.01.2022.
//

import Foundation
import SwiftUI
import Models

final class ScreenBuilderStatic {
    @ViewBuilder
    class func buildsScreen(app: V0AppResponseItemModel? = nil) -> some View {
        BuildsScreenView()
            .environmentObject(app == nil ? ViewModelResolver.resolve(BuildsViewModel.self) : BuildsViewModel(app: app))
            .navigationTitle(app?.title ?? "Builds")
            .modifier(ThemeBackground())
    }
    
    @ViewBuilder
    class func buildScreen(build: BuildResponseItemModel) -> some View {
        BuildScreenView()
            .environmentObject(ViewModelResolver.build(build))
            .navigationTitle("Build #\(String(build.buildNumber))")
            .modifier(ThemeBackground())
    }
    
    @ViewBuilder
    class func logsScreen(build: BuildResponseItemModel) -> some View {
        LogsScreenView(build: build)
            .navigationTitle("Build #\(String(build.buildNumber)) logs")
    }
    
    @ViewBuilder
    class func artifactsScreen(build: BuildResponseItemModel) -> some View {
        ArtifactsScreenView(build: build)
            .navigationTitle("Build #\(String(build.buildNumber)) artifacts")
    }
    
    @ViewBuilder
    class func appsScreen() -> some View {
        AppsScreenView()
            .environmentObject(ViewModelResolver.resolve(AppsViewModel.self))
            .navigationTitle("Apps")
            .modifier(ThemeBackground())
    }
    
    @ViewBuilder
    class func appSelectScreen(completion: @escaping ((V0AppResponseItemModel) -> Void)) -> some View {
        AppsScreenView(completion: completion)
            .environmentObject(ViewModelResolver.resolve(AppsViewModel.self))
            .navigationTitle("Select the app")
    }
    
    @ViewBuilder
    class func accountsScreen() -> some View {
        AccountsScreenView()
            .navigationTitle("Accounts")
            .modifier(ThemeBackground())
    }
    
    @ViewBuilder
    class func activitiesScreen() -> some View {
        ActivitiesScreenView()
            .environmentObject(ViewModelResolver.resolve(ActivitiesViewModel.self))
            .navigationTitle("Activities")
            .modifier(ThemeBackground())
    }
    
    @ViewBuilder
    class func authScreen(canClose: Bool = false, onCompletion: (() -> Void)? = nil) -> some View {
        ThemeConfiguratorView {
            AuthScreenView(canClose: canClose, onCompletion: onCompletion)
        }
    }
    
    @ViewBuilder
    class func newBuildScreen(app: V0AppResponseItemModel? = nil) -> some View {
        NewBuildScreenView(app: app)
            .navigationTitle("Start a build")
    }
    
    @ViewBuilder
    class func debugScreen() -> some View {
        ThemeConfiguratorView {
            DebugScreenView()
                .navigationTitle("Debug")
        }
    }
}