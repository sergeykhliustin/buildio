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
    case builds(V0AppResponseItemModel)
    case build(BuildResponseItemModel)
    case logs(BuildResponseItemModel)
    case artifacts(BuildResponseItemModel)
}

protocol RoutingView: ScreenBuilder {
    
}

extension RoutingView {
    
    @ViewBuilder func navigationLinks(route: Binding<Route?>) -> some View {
        ZStack {
            NavigationLink(unwrapping: route, case: /Route.builds) { app in
                buildsScreen(app: app.wrappedValue)
            } onNavigate: { _ in
                
            } label: {
                EmptyView()
            }
            .hidden()
            
            NavigationLink(unwrapping: route, case: /Route.build) { build in
                buildScreen(build: build.wrappedValue)
            } onNavigate: { isActive in
                
            } label: {
                EmptyView()
            }
            .hidden()
            
            NavigationLink(unwrapping: route, case: /Route.logs) { build in
                logsScreen(build: build.wrappedValue)
            } onNavigate: { _ in
                
            } label: {
                EmptyView()
            }
            .hidden()
            
            NavigationLink(unwrapping: route, case: /Route.artifacts) { build in
                artifactsScreen(build: build.wrappedValue)
            } onNavigate: { _ in
                
            } label: {
                EmptyView()
            }
            .hidden()
        }
        .frame(width: 0, height: 0)
    }
}
