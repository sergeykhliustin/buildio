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
    
}

extension ScreenBuilder {
    @ViewBuilder
    func buildsScreen(app: V0AppResponseItemModel? = nil) -> some View {
        ScreenBuilderStatic.buildsScreen(app: app)
    }
    
    @ViewBuilder
    func buildScreen(build: BuildResponseItemModel) -> some View {
        ScreenBuilderStatic.buildScreen(build: build)
    }
    
    @ViewBuilder
    func logsScreen(build: BuildResponseItemModel) -> some View {
        ScreenBuilderStatic.logsScreen(build: build)
    }
    
    @ViewBuilder
    func artifactsScreen(build: BuildResponseItemModel) -> some View {
        ScreenBuilderStatic.artifactsScreen(build: build)
    }
    
    @ViewBuilder
    func appsScreen() -> some View {
        ScreenBuilderStatic.appsScreen()
    }
    
    @ViewBuilder
    func appSelectScreen(completion: @escaping ((V0AppResponseItemModel) -> Void)) -> some View {
        ScreenBuilderStatic.appSelectScreen(completion: completion)
    }
    
    @ViewBuilder
    func accountsScreen() -> some View {
        ScreenBuilderStatic.accountsScreen()
    }
    
    @ViewBuilder
    func activitiesScreen() -> some View {
        ScreenBuilderStatic.activitiesScreen()
    }
    
    @ViewBuilder
    func authScreen(canClose: Bool = false, onCompletion: (() -> Void)? = nil) -> some View {
        ScreenBuilderStatic.authScreen(canClose: canClose, onCompletion: onCompletion)
    }
    
    @ViewBuilder
    func newBuildScreen(app: V0AppResponseItemModel? = nil) -> some View {
        ScreenBuilderStatic.newBuildScreen(app: app)
    }
    
    @ViewBuilder
    func debugScreen() -> some View {
        ScreenBuilderStatic.debugScreen()
    }
}
