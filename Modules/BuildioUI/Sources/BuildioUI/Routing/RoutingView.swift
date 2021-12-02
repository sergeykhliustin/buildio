//
//  RoutingView.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 17.11.2021.
//

import SwiftUI
import Models
import SwiftUINavigation

enum Route {
    case build(BuildResponseItemModel)
    case logs(BuildResponseItemModel)
    case artifacts(BuildResponseItemModel)
}

protocol RoutingView: View {
    
}

extension RoutingView {
    
    @ViewBuilder func navigationBuilds(app: Binding<V0AppResponseItemModel?>) -> some View {
        NavigationLink(unwrapping: app) { app in
            BuildsScreenView(app: app.wrappedValue)
                .navigationTitle(app.wrappedValue.title)
        } onNavigate: { isActive in
            
        } label: {
            EmptyView()
        }
        .hidden()
    }
    
    @ViewBuilder func navigationBuild(build: Binding<BuildResponseItemModel?>) -> some View {
        NavigationLink(unwrapping: build) { build in
            BuildScreenView(build: build)
                .navigationTitle("Build #\(String(build.wrappedValue.buildNumber))")
        } onNavigate: { isActive in
            logger.debug("")
        } label: {
            EmptyView()
        }
        .hidden()
    }
    
    @ViewBuilder func navigationBuild(route: Binding<Route?>) -> some View {
        NavigationLink(unwrapping: route, case: /Route.build) { build in
            BuildScreenView(build: build)
                .navigationTitle("Build #\(String(build.wrappedValue.buildNumber))")
        } onNavigate: { isActive in
            
        } label: {
            EmptyView()
        }
        .hidden()

    }
    
    @ViewBuilder func navigationBuildLogs(build: Binding<BuildResponseItemModel?>) -> some View {
        NavigationLink(unwrapping: build) { build in
            LogsScreenView(build: build.wrappedValue)
        } onNavigate: { isActive in
            
        } label: {
            EmptyView()
        }
        .hidden()
    }
    
    @ViewBuilder func navigationBuildLogs(route: Binding<Route?>) -> some View {
        NavigationLink(unwrapping: route, case: /Route.logs) { build in
            LogsScreenView(build: build.wrappedValue)
        } onNavigate: { _ in
            
        } label: {
            EmptyView()
        }
        .hidden()
    }
    
    @ViewBuilder func navigationBuildArtifacts(route: Binding<Route?>) -> some View {
        NavigationLink(unwrapping: route, case: /Route.artifacts) { build in
            ArtifactsScreenView(build: build.wrappedValue)
                .navigationTitle("Artifacts")
        } onNavigate: { _ in
            
        } label: {
            EmptyView()
        }
        .hidden()
    }
}
