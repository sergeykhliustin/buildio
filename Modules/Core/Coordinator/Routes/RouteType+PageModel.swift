//
//  PushRoute+PageModel.swift
//  Modules
//
//  Created by Sergii Khliustin on 03.11.2024.
//

import Foundation
import Dependencies
import UITypes
import Builds
import Apps
import Activities
import Build
import BuildYml
import Accounts
import Auth
import BuildLog
import StartBuild
import AbortBuild
import Settings
import Artifacts
import WebFlow

extension RouteType {
    @MainActor
    func viewModel(dependencies: Dependencies) -> PageModelType {
        let pageModel: PageModelType
        switch self {
        case .empty:
            fatalError("Should not be called")
        case .builds(let app):
            pageModel = BuildsPageModel(dependencies: dependencies, app: app)
        case .apps:
            pageModel = AppsPageModel(dependencies: dependencies)
        case .activities:
            pageModel = ActivitiesPageModel(dependencies: dependencies)
        case .build(let build):
            pageModel = BuildPageModel(dependencies: dependencies, build: build)
        case .yml(let build):
            pageModel = BuildYmlPageModel(dependencies: dependencies, build: build)
        case .accounts:
            pageModel = AccountsPageModel(dependencies: dependencies)
        case .auth(let canDemo):
            pageModel = AuthPageModel(dependencies: dependencies, canDemo: canDemo)
        case .logs(let build):
            pageModel = BuildLogPageModel(dependencies: dependencies, build: build)
        case .startBuild(let app):
            pageModel = StartBuildPageModel(dependencies: dependencies, app: app)
        case .appSelector(let completion):
            pageModel = AppsPageModel(dependencies: dependencies, completion: completion)
        case .branchSelector(let app, let completion):
            pageModel = SelectBranchPageModel(dependencies: dependencies, app: app, completion: completion)
        case .workflowSelector(let app, let completion):
            pageModel = SelectWorkflowPageModel(dependencies: dependencies, app: app, completion: completion)
        case .abortBuild(let build):
            pageModel = AbortBuildPageModel(dependencies: dependencies, build: build)
        case .settings:
            pageModel = SettingsPageModel(dependencies: dependencies)
        case .about:
            pageModel = AboutPageModel(dependencies: dependencies)
        case .artifacts(let build):
            pageModel = ArtifactsPageModel(dependencies: dependencies, build: build)
        case .web(let url):
            pageModel = WebFlowPageModel(dependencies: dependencies, url: url)
        }
        return pageModel
    }
}
