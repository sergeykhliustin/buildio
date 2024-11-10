//
//  RootPageModel.swift
//  Modules
//
//  Created by Sergii Khliustin on 03.11.2024.
//

import Foundation
import SwiftUI
import FlowStacks
import Dependencies
import UITypes
import Logger
import Observation

private extension FlowPath {
    mutating func dismiss() {
        guard let route = routes.last else { return }
        if route.isPresented {
            routes.dismiss()
        } else {
            routes.pop()
        }
    }
}

@MainActor
final class RootPageModel: ObservableObject, NavigatorType {
    struct CombinedPath {
        var primary: FlowPath = FlowPath()
        var secondary: FlowPath = FlowPath()
    }
    @Published var path: CombinedPath = CombinedPath() {
        didSet {
            onPathChange()
        }
    }
    @Published var windowMode: WindowMode { didSet { onWindowModeChange(oldValue) }}
    var shouldSplit: Bool {
        windowMode == .split && !path.secondary.routes.filter { !$0.isPresented }.isEmpty
    }
    let root: RouteType
    private let viewModelFactory: (NavigatorType, RouteType) -> PageModelType
    private var viewModels: [RouteType: PageModelType] = [:]

    init(
        root: RouteType,
        windowMode: WindowMode,
        viewModelFactory: @escaping (NavigatorType, RouteType) -> PageModelType
    ) {
        self.root = root
        self.windowMode = windowMode
        self.viewModelFactory = viewModelFactory
    }

    deinit {
        logger.debug("RootPageModel deinit")
    }

    func reset() {
        viewModels.values.forEach { $0.unsubscribe() }
        viewModels.removeAll()
        path = CombinedPath()
    }

    func viewModel(for route: RouteType) -> PageModelType {
        if let viewModel = viewModels[route] {
            return viewModel
        }
        let viewModel = viewModelFactory(self, route)
        viewModels[route] = viewModel
        return viewModel
    }

    func show(_ path: RouteType) {
        switch path.style {
        case .push:
            if windowMode == .split {
                if self.path.primary.routes.contains(where: { $0.isPresented }) {
                    self.path.primary.push(path)
                } else if let last = self.path.secondary.routes.first?.screen as? RouteType, path.shouldReplace(last) {
                    self.path.secondary = FlowPath([.push(path)])
                } else {
                    self.path.secondary.push(path)
                }
            } else {
                self.path.primary.push(path)
            }
        case .sheet:
            self.path.primary.presentSheet(path, withNavigation: path.navigation)
        }
    }

    func dismissAll() {
        path = CombinedPath()
    }

    func dismiss() {
        if let sheet = path.primary.routes.last, sheet.isPresented {
            path.primary.dismiss()
        } else if windowMode == .split {
            path.secondary.dismiss()
        } else {
            path.primary.dismiss()
        }
    }

    private func onWindowModeChange(_ oldValue: WindowMode) {
        guard windowMode != oldValue else { return }
        withAnimation(.none) {
            if windowMode == .split {
                if let sheetIndex = path.primary.routes.firstIndex(where: { $0.isPresented }) {
                    let primaryRoutes = path.primary.routes.suffix(from: sheetIndex)
                    let secondaryRoutes = path.primary.routes.prefix(sheetIndex).dropLast()
                    path = CombinedPath(primary: FlowPath(primaryRoutes), secondary: FlowPath(secondaryRoutes))
                } else {
                    path = CombinedPath(secondary: FlowPath(path.primary.routes + path.secondary.routes))
                }
            } else {
                if let sheetIndex = path.primary.routes.firstIndex(where: { $0.isPresented }) {
                    let rootRoutes = path.primary.routes.prefix(sheetIndex).dropLast()
                    let secondaryRoutes = path.secondary.routes
                    path = CombinedPath(primary: FlowPath(rootRoutes + secondaryRoutes))
                } else {
                    let routes = path.primary.routes + path.secondary.routes
                    path = CombinedPath(primary: FlowPath(routes))
                }
            }
        }
    }

    private func onPathChange() {
        let primaryPath = path.primary.routes.map { $0.screen }
        let secondaryPath = path.secondary.routes.map { $0.screen }
        let filteredViewModels = viewModels.filter { (key, value) in
            key == self.root || primaryPath.contains(key) || secondaryPath.contains(key)
        }
        viewModels = filteredViewModels
    }
}
