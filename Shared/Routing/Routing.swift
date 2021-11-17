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
    
    @ViewBuilder func view(for route: Route, params: Any?) -> Self.View
}

extension Routing {
    func navigationLink<R: RouteType>(route: R, selection: Binding<R?>, params: Any? = nil) -> NavigationLink<EmptyView, Self.View> where R == Self.Route {
        NavigationLink(route: route, selection: selection, router: self, params: params)
    }
    
    func navigationLink<R: RouteType>(route: R, isActive: Binding<Bool>, params: Any? = nil) -> NavigationLink<EmptyView, Self.View> where R == Self.Route {
        NavigationLink(route: route, isActive: isActive, router: self, params: params)
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
    case buildScreen
    case logsScreen
    case buildsScreen(V0AppResponseItemModel?)
    case appsScreen
}

struct AppRouter: Routing {
    @ViewBuilder
    func view(for route: AppRoute, params: Any? = nil) -> some View {
        switch route {
        case .buildScreen:
            if let model = params as? BuildResponseItemModel {
                BuildScreenView(build: model)
            }
        case .logsScreen:
            if let params = params as? BuildResponseItemModel {
                LogsScreenView(build: params)
            }
            
        case .buildsScreen(let model):
            if let model = model {
                BuildsScreenView(app: model)
                    .navigationTitle(model.title)
            } else {
                BuildsScreenView(app: model)
            }
        case .appsScreen:
            AppsScreenView()
        }
    }
}

protocol AppMultiRouteView: MultiRouteView where Router == AppRouter {
    
}

protocol AppOneRouteView: OneRouteView where Router == AppRouter {
    
}

extension NavigationLink where Destination: View, Label == EmptyView {
    init<R: RouteType, T: Routing>(route: R, selection: Binding<R?>, router: T, params: Any? = nil) where T.Route == R, Destination == T.View {
        self.init(tag: route, selection: selection, destination: {
            router.view(for: route, params: params)
        }, label: {
            EmptyView()
        })
    }
    
    init<R: RouteType, T: Routing>(route: R, isActive: Binding<Bool>, router: T, params: Any? = nil) where T.Route == R, Destination == T.View {
        self.init(isActive: isActive, destination: {
            router.view(for: route, params: params)
        }, label: {
            EmptyView()
        })
    }
}