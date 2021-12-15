//
//  ScreenBuilder.swift
//  
//
//  Created by Sergey Khliustin on 04.12.2021.
//

import Models
import SwiftUI
import Introspect

struct ThemeBackground: ViewModifier {
    @Environment(\.theme) var theme
    
    func body(content: Content) -> some View {
        content
            .introspectViewController { controller in
                controller.applyTheme(theme)
            }
            .introspectSplitViewController { controller in
                controller.applyTheme(theme)
            }
    }
}

protocol ScreenBuilder: View {
    var theme: Theme { get }
}

extension ScreenBuilder {
    @ViewBuilder
    func buildsScreen(app: V0AppResponseItemModel? = nil) -> some View {
        BuildsScreenView()
            .environmentObject(app == nil ? ViewModelResolver.resolve(BuildsViewModel.self) : BuildsViewModel(app: app))
            .navigationTitle(app?.title ?? "Builds")
            .modifier(ThemeBackground())
    }
    
    @ViewBuilder
    func buildScreen(build: BuildResponseItemModel) -> some View {
        BuildScreenView()
            .environmentObject(ViewModelResolver.build(build))
            .navigationTitle("Build #\(String(build.buildNumber))")
            .modifier(ThemeBackground())
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
            .modifier(ThemeBackground())
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
            .modifier(ThemeBackground())
    }
    
    @ViewBuilder
    func activitiesScreen() -> some View {
        ActivitiesScreenView()
            .navigationTitle("Activities")
            .modifier(ThemeBackground())
    }
    
    @ViewBuilder
    func authScreen(canClose: Bool = false, onCompletion: (() -> Void)? = nil) -> some View {
        ThemeConfiguratorView {
            AuthScreenView(canClose: canClose, onCompletion: onCompletion)
        }
    }
    
    @ViewBuilder
    func newBuildScreen(app: V0AppResponseItemModel? = nil) -> some View {
        ThemeConfiguratorView {
            NavigationView {
                NewBuildScreenView(app: app)
                    .navigationTitle("Start a build")
            }
        }
    }
    
    @ViewBuilder
    func debugScreen() -> some View {
        ThemeConfiguratorView {
            DebugScreenView()
                .navigationTitle("Debug")
        }
    }
}
