//
//  Navigator.swift
//  SplitNavigation
//
//  Created by Sergey Khliustin on 18.01.2022.
//

import Foundation
import UIKit
import SwiftUI
import Models

enum Route {
    case builds(V0AppResponseItemModel)
    case build(BuildResponseItemModel)
    case logs(BuildResponseItemModel)
    case artifacts(BuildResponseItemModel)
}

enum NewBuildRoute {
    case newBuild(V0AppResponseItemModel?)
    case appSelect((V0AppResponseItemModel) -> Void)
}

enum AuthRoute {
    case auth((() -> Void)?)
}

final class Navigator: ObservableObject {
    private let parent: Navigator?
    private weak var child: Navigator?
    weak var navigationController: SplitNavigationController?
    private(set) var route: Route?
    
    init(parent: Navigator? = nil) {
        self.parent = parent
    }
    
    func popToRoot() {
        navigationController?.popToRoot()
    }
    
    func go(_ route: Route) {
        let builder = ScreenBuilderStatic.self
        var controller: UIViewController!
        switch route {
        case .builds(let app):
            controller = builder.buildsScreen(app: app).hosting
        case .build(let build):
            controller = builder.buildScreen(build: build).hosting
        case .logs(let build):
            controller = builder.logsScreen(build: build).hosting
        case .artifacts(let build):
            controller = builder.artifactsScreen(build: build).hosting
        }
        navigationController?.push(controller, shouldReplace: !shouldChain(route, prevRoute: self.route))
        self.route = route
    }
    
    func go(_ route: NewBuildRoute) {
        let builder = ScreenBuilderStatic.self
        switch route {
        case .newBuild(let app):
            let navigator = Navigator(parent: self)
            self.child = navigator
            let controller = SplitNavigationView(shouldSplit: false) {
                builder.newBuildScreen(app: app)
            }
                .environmentObject(navigator)
                .hosting
            
            navigationController?.sheet(controller)
        case .appSelect(let completion):
            let controller = builder.appSelectScreen(completion: completion).hosting
            navigationController?.push(controller, shouldReplace: false)
        }
    }
    
    func go(_ route: AuthRoute) {
        let builder = ScreenBuilderStatic.self
        switch route {
        case .auth(let completion):
            let navigator = Navigator(parent: self)
            self.child = navigator
            let controller = SplitNavigationView(shouldSplit: false) {
                builder.authScreen(canClose: true, onCompletion: completion)
            }
                .environmentObject(navigator)
                .hosting
            navigationController?.sheet(controller)
        }
    }
    
    func dismiss() {
        if let parent = parent {
            parent.dismiss(child: self)
        }
    }
    
    func dismiss(child: Navigator) {
        if self.child === child {
            navigationController?.dismissSheet()
            self.child = nil
        }
    }
    
    private func shouldChain(_ route: Route, prevRoute: Route?) -> Bool {
        switch (route, prevRoute) {
        case (.logs(let logsBuild), .build(let build)):
            return logsBuild == build
        case (.artifacts(let artifacts), .build(let build)):
            return artifacts == build
        case (.logs, .builds):
            return true
        case (.artifacts, .builds):
            return true
        default:
            return false
        }
    }
}
