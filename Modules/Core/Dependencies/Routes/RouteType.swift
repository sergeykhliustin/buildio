//
//  PushRoute.swift
//  Modules
//
//  Created by Sergii Khliustin on 03.11.2024.
//
import Models
import SwiftUI

package enum RouteType: Hashable {
    package enum Style {
        case push
        case sheet
    }

    case empty
    case builds(app: V0AppResponseItemModel? = nil)
    case apps
    case accounts
    case settings
    case activities
    case build(BuildResponseItemModel)
    case logs(BuildResponseItemModel)
    case artifacts(BuildResponseItemModel)
    case yml(BuildResponseItemModel)
    case auth
    case startBuild(app: V0AppResponseItemModel? = nil)
    case branchSelector(app: V0AppResponseItemModel, completion: (String) -> Void)
    case workflowSelector(app: V0AppResponseItemModel, completion: (String) -> Void)
    case appSelector(completion: (V0AppResponseItemModel) -> Void)
    case abortBuild(BuildResponseItemModel)
    case about

    package var style: Style {
        switch self {
        case .auth, .startBuild, .abortBuild:
            return .sheet
        default:
            return .push
        }
    }

    package var navigation: Bool {
        switch self {
        case .abortBuild:
            return false
        default:
            return true
        }
    }

    package func shouldReplace(_ other: Self?) -> Bool {
        guard let other else { return true }
        guard self != other else { return true }
        switch (self, other) {
        case (.builds, .builds):
            return true
        case (.build, .build):
            return true
        default:
            return false
        }
    }

    package static func == (lhs: RouteType, rhs: RouteType) -> Bool {
        switch (lhs, rhs) {
        case (.empty, .empty):
            return true
        case (.builds(let lhsApp), .builds(let rhsApp)):
            return lhsApp == rhsApp
        case (.apps, .apps):
            return true
        case (.accounts, .accounts):
            return true
        case (.settings, .settings):
            return true
        case (.activities, .activities):
            return true
        case (.build(let lhsBuild), .build(let rhsBuild)):
            return lhsBuild == rhsBuild
        case (.logs(let lhsBuild), .logs(let rhsBuild)):
            return lhsBuild == rhsBuild
        case (.artifacts(let lhsBuild), .artifacts(let rhsBuild)):
            return lhsBuild == rhsBuild
        case (.yml(let lhsBuild), .yml(let rhsBuild)):
            return lhsBuild == rhsBuild
        case (.auth, .auth):
            return true
        case (.startBuild(let lhsApp), .startBuild(let rhsApp)):
            return lhsApp == rhsApp
        case (.branchSelector(let lhsApp, _), .branchSelector(let rhsApp, _)):
            return lhsApp == rhsApp
        case (.workflowSelector(let lhsApp, _), .workflowSelector(let rhsApp, _)):
            return lhsApp == rhsApp
        case (.appSelector, .appSelector):
            return true
        case (.abortBuild(let lhsBuild), .abortBuild(let rhsBuild)):
            return lhsBuild == rhsBuild
        case (.about, .about):
            return true
        default:
            return false
        }
    }

    package func hash(into hasher: inout Hasher) {
        switch self {
        case .empty:
            hasher.combine(0)
        case .builds:
            hasher.combine(1)
        case .apps:
            hasher.combine(2)
        case .accounts:
            hasher.combine(3)
        case .settings:
            hasher.combine(4)
        case .activities:
            hasher.combine(5)
        case .build(let build):
            hasher.combine(7)
            hasher.combine(build)
        case .logs(let build):
            hasher.combine(8)
            hasher.combine(build)
        case .artifacts(let build):
            hasher.combine(9)
            hasher.combine(build)
        case .yml(let build):
            hasher.combine(10)
            hasher.combine(build)
        case .auth:
            hasher.combine(11)
        case .startBuild(let app):
            hasher.combine(12)
            hasher.combine(app)
        case .branchSelector(let app, _):
            hasher.combine(13)
            hasher.combine(app)
        case .workflowSelector(let app, _):
            hasher.combine(14)
            hasher.combine(app)
        case .appSelector:
            hasher.combine(15)
        case .abortBuild(let build):
            hasher.combine(16)
            hasher.combine(build)
        case .about:
            hasher.combine(17)
        }
    }
}
