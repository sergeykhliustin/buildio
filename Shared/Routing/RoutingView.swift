//
//  RoutingView.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 17.11.2021.
//

import SwiftUI
import Models

protocol RoutingView: View {
    associatedtype BuildsRouteBody: View
    associatedtype BuildRouteBody: View
    associatedtype LogsRouteBody: View
    
    @ViewBuilder func navigationBuilds(app: V0AppResponseItemModel, selection: Binding<String?>) -> BuildsRouteBody
    @ViewBuilder func navigationBuild(build: BuildResponseItemModel, selection: Binding<String?>) -> BuildRouteBody
    @ViewBuilder func navigationBuildLogs(build: BuildResponseItemModel, isActive: Binding<Bool>) -> LogsRouteBody
//    @ViewBuilder func navigationBuildLogs(build: BuildResponseItemModel, selection: Binding<String?>) -> LogsRouteBody
}

extension RoutingView {
    @ViewBuilder func navigationBuilds(app: V0AppResponseItemModel, selection: Binding<String?>) -> some View {
        NavigationLink(tag: app.slug, selection: selection, destination: {
            BuildsScreenView(app: app)
                .navigationTitle(app.title)
        }, label: {
            EmptyView()
        })
            .hidden()
    }
    
    @ViewBuilder func navigationBuild(build: BuildResponseItemModel, selection: Binding<String?>) -> some View {
        NavigationLink(tag: build.slug, selection: selection, destination: {
            BuildScreenView(build: build)
        }, label: {
            EmptyView()
        })
            .hidden()
    }
    
    @ViewBuilder func navigationBuildLogs(build: BuildResponseItemModel, isActive: Binding<Bool>) -> some View {
        NavigationLink(isActive: isActive, destination: {
            LogsScreenView(build: build)
        }, label: {
            EmptyView()
        })
            .hidden()
    }
    
    @ViewBuilder func navigationBuildLogs(build: BuildResponseItemModel, selection: Binding<String?>) -> some View {
        NavigationLink(tag: build.slug, selection: selection, destination: {
            LogsScreenView(build: build)
        }, label: {
            EmptyView()
        })
            .hidden()
    }
}
