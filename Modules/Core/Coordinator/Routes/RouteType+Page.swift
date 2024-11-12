//
//  PushRoute+Page.swift
//  Modules
//
//  Created by Sergii Khliustin on 03.11.2024.
//

import Foundation
import SwiftUI
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

// swiftlint:disable force_cast
extension RouteType {
    @MainActor
    @ViewBuilder
    func view(viewModel: PageModelType) -> some View {
        switch self {
        case .empty:
            EmptyView()
        case .builds:
            BuildsPage(viewModel: viewModel as! BuildsPageModel)
        case .apps:
            AppsPage(viewModel: viewModel as! AppsPageModel)
        case .activities:
            ActivitiesPage(viewModel: viewModel as! ActivitiesPageModel)
        case .build:
            BuildPage(viewModel: viewModel as! BuildPageModel)
        case .yml:
            BuildYmlPage(viewModel: viewModel as! BuildYmlPageModel)
        case .accounts:
            AccountsPage(viewModel: viewModel as! AccountsPageModel)
        case .auth:
            AuthPage(viewModel: viewModel as! AuthPageModel)
        case .logs:
            BuildLogPage(viewModel: viewModel as! BuildLogPageModel)
        case .startBuild:
            StartBuildPage(viewModel: viewModel as! StartBuildPageModel)
        case .appSelector:
            AppsPage(viewModel: viewModel as! AppsPageModel)
        case .branchSelector:
            SelectBranchPage(viewModel: viewModel as! SelectBranchPageModel)
        case .workflowSelector:
            SelectWorkflowPage(viewModel: viewModel as! SelectWorkflowPageModel)
        case .abortBuild:
            AbortBuildPage(viewModel: viewModel as! AbortBuildPageModel)
        case .settings:
            SettingsPage(viewModel: viewModel as! SettingsPageModel)
        case .about:
            AboutPage(viewModel: viewModel as! AboutPageModel)
        case .artifacts:
            ArtifactsPage(viewModel: viewModel as! ArtifactsPageModel)
        case .web:
            WebFlowPage(viewModel: viewModel as! WebFlowPageModel)
        }
    }
}
// swiftlint:enable force_cast
