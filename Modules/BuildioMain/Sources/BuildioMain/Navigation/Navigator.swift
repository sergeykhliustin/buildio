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
    case activities
}

enum NewBuildRoute {
    case newBuild(V0AppResponseItemModel?)
    case appSelect((V0AppResponseItemModel) -> Void)
}

enum AuthRoute {
    case auth((() -> Void)?)
}

enum SettingsRoute {
    case debugLogs
    case themeLight
    case themeDark
    case debug
}

final class Navigator: ObservableObject {
    private let screenFactory: ScreenFactory
    private weak var parentNavigators: Navigators?
    private let parent: Navigator?
    private weak var child: Navigator?
    weak var navigationController: SplitNavigationController?
    private(set) var isPresentingSheet: Bool = false {
        didSet {
            parentNavigators?.updatePresenting()
        }
    }
    
    init(_ parent: Navigators, factory: ScreenFactory) {
        self.parentNavigators = parent
        self.parent = nil
        self.screenFactory = factory
    }
    
    init(_ parent: Navigator) {
        self.parent = parent
        self.parentNavigators = nil
        self.screenFactory = parent.screenFactory
    }
    
    func popToRoot() {
        navigationController?.popToRoot()
    }
    
    @MainActor
    func go(_ route: Route, replace: Bool) {
        let builder = screenFactory
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
        case .activities:
            controller = builder.activitiesScreen().hosting
        }
        navigationController?.push(controller, shouldReplace: replace)
    }
    
    @MainActor
    func go(_ route: NewBuildRoute) {
        let builder = screenFactory
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
    
    @MainActor
    func go(_ route: AuthRoute) {
        let builder = screenFactory
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
    
    @MainActor
    func go(_ route: SettingsRoute) {
        let builder = screenFactory
        var controller: UIViewController!
        switch route {
        case .debugLogs:
            controller = builder.debugLogsScreen().hosting
        case .themeLight:
            controller = builder.themeScreen(theme: Theme.defaultTheme(for: .light)).hosting
        case .themeDark:
            controller = builder.themeScreen(theme: Theme.defaultTheme(for: .dark)).hosting
        case .debug:
            controller = builder.debugScreen().hosting
        }
        navigationController?.push(controller, shouldReplace: false)
    }
    
    func go<Content: View>(_ content: () -> Content) {
        let controller = content().hosting
        navigationController?.push(controller, shouldReplace: false)
    }
    
    func dismiss() {
        if let parent = parent {
            parent.dismiss(child: self)
        } else if let child = child {
            dismiss(child: child)
        } else {
            navigationController?.pop()
        }
    }
    
    func dismiss(child: Navigator) {
        if self.child === child {
            navigationController?.dismissSheet({
                self.child = nil
                self.isPresentingSheet = false
            })
        }
    }
}
