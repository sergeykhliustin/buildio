//
//  Routing.swift
//  Buildio
//
//  Created by Sergey Khliustin on 04.11.2021.
//

import Foundation
import SwiftUI
import Combine
import Models

typealias RouteType = Hashable

protocol Routing {
    associatedtype Route
    associatedtype View: SwiftUI.View
    
    @ViewBuilder func view(for route: Route) -> Self.View
}

extension Routing {
    func navigationLink<R: RouteType>(route: R, selection: Binding<R?>) -> NavigationLink<EmptyView, Self.View> where R == Self.Route {
        NavigationLink(route: route, selection: selection, router: self)
    }
    
    func navigationLink<R: RouteType>(route: R, isActive: Binding<Bool>) -> NavigationLink<EmptyView, Self.View> where R == Self.Route {
        NavigationLink(route: route, isActive: isActive, router: self)
    }
}

protocol MultiRouteView: View {
    associatedtype Router: Routing
    
    var router: Router { get }
    var activeRoute: Router.Route? { get }
}

protocol OneRouteView: View {
    associatedtype Router: Routing
    
    var router: Router { get }
    var isActiveRoute: Bool { get }
}

enum AppRoute: RouteType {
    case buildScreen(BuildResponseItemModel)
    case logsScreen(BuildResponseItemModel)
    case buildsScreen(V0AppResponseItemModel?)
}

struct AppRouter: Routing {
    @ViewBuilder
    func view(for route: AppRoute) -> some View {
        switch route {
        case .buildScreen(let model):
            BuildScreenView(build: model)
        case .logsScreen(let model):
            LogsScreenView(build: model)
            
        case .buildsScreen(let model):
            if let model = model {
                BuildsScreenView(app: model)
                    .navigationTitle(model.title)
            } else {
                BuildsScreenView(app: model)
            }
            
        }
    }
}

protocol AppMultiRouteView: MultiRouteView where Router == AppRouter {
    
}

protocol AppOneRouteView: OneRouteView where Router == AppRouter {
    
}

extension NavigationLink where Destination: View, Label == EmptyView {
    init<R: RouteType, T: Routing>(route: R, selection: Binding<R?>, router: T) where T.Route == R, Destination == T.View {
        self.init(tag: route, selection: selection, destination: {
            router.view(for: route)
        }, label: {
            EmptyView()
        })
    }
    
    init<R: RouteType, T: Routing>(route: R, isActive: Binding<Bool>, router: T) where T.Route == R, Destination == T.View {
        self.init(isActive: isActive, destination: {
            router.view(for: route)
        }, label: {
            EmptyView()
        })
    }
}
