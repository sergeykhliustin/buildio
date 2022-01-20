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

enum DebugRoute {
    case debugLogs
    case theme
}

final class Navigator: ObservableObject {
    private weak var parentNavigators: Navigators?
    private let parent: Navigator?
    private weak var child: Navigator?
    weak var navigationController: SplitNavigationController?
    private(set) var route: Route?
    private(set) var isPresentingSheet: Bool = false {
        didSet {
            parentNavigators?.updatePresenting()
        }
    }
    
    init(_ parent: Navigators?) {
        self.parentNavigators = parent
        self.parent = nil
    }
    
    init(_ parent: Navigator?) {
        self.parent = parent
        self.parentNavigators = nil
    }
    
    init() {
        self.parent = nil
        self.parentNavigators = nil
    }
    
    func popToRoot() {
        navigationController?.popToRoot()
    }
    
    func go(_ route: Route) {
        let builder = ScreenBuilder.self
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
        let builder = ScreenBuilder.self
        switch route {
        case .newBuild(let app):
            let navigator = Navigator(self)
            self.child = navigator
            let controller = SplitNavigationView(shouldSplit: false) {
                builder.newBuildScreen(app: app)
            }
                .environmentObject(navigator)
                .hosting
            
            navigationController?.sheet(controller)
            self.isPresentingSheet = true
            
        case .appSelect(let completion):
            let controller = builder.appSelectScreen(completion: completion).hosting
            navigationController?.push(controller, shouldReplace: false)
        }
    }
    
    func go(_ route: AuthRoute) {
        let builder = ScreenBuilder.self
        switch route {
        case .auth(let completion):
            let navigator = Navigator(self)
            self.child = navigator
            let controller = SplitNavigationView(shouldSplit: false) {
                builder.authScreen(canClose: true, onCompletion: completion)
            }
                .environmentObject(navigator)
                .hosting
            self.isPresentingSheet = true
            navigationController?.sheet(controller)
        }
    }
    
    func go(_ route: DebugRoute) {
        let builder = ScreenBuilder.self
        var controller: UIViewController!
        switch route {
        case .debugLogs:
            controller = builder.debugLogsScreen().hosting
        case .theme:
            controller = builder.themeScreen().hosting
        }
        navigationController?.push(controller, shouldReplace: false)
    }
    
    func dismiss() {
        if let parent = parent {
            parent.dismiss(child: self)
        } else if let child = child {
            dismiss(child: child)
        }
    }
    
    func dismiss(child: Navigator) {
        if self.child === child {
            navigationController?.dismissSheet()
            self.child = nil
            self.isPresentingSheet = false
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
