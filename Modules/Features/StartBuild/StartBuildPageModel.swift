//
//  StartBuildPageModel.swift
//  Modules
//
//  Created by Sergii Khliustin on 07.11.2024.
//

import Foundation
import UITypes
import Dependencies
import API
import Models

package final class StartBuildPageModel: PageModelType {
    struct Params {
        var appSlug: String = ""
        var branch: String = ""
        var workflow: String = ""
        var message: String = ""

        var isValid: Bool {
            return !appSlug.isEmpty && !branch.isEmpty && !workflow.isEmpty
        }
    }
    @Published var app: V0AppResponseItemModel? {
        didSet {
            params.appSlug = app?.slug ?? ""
            params.branch = ""
            params.workflow = ""
        }
    }
    @Published var params: Params

    package init(dependencies: DependenciesType, app: V0AppResponseItemModel?) {
        self.app = app
        var params = Params()
        if let app = app {
            params.appSlug = app.slug
        }
        self.params = params
        super.init(dependencies: dependencies)
    }

    func onAppSelect() {
        dependencies.navigator.show(.appSelector(completion: { app in
            self.app = app
        }))
    }

    func onBranchSelect() {
        guard let app else { return }
        dependencies.navigator.show(.branchSelector(app: app, completion: { branch in
            self.params.branch = branch
        }))
    }

    func onWorkflowSelect() {
        guard let app else { return }
        dependencies.navigator.show(.workflowSelector(app: app, completion: { workflow in
            self.params.workflow = workflow
        }))
    }

    func onStartBuild() {
        guard let app else { return }
        guard params.isValid else { return }
        let commitMessage = params.message.isEmpty ? nil : params.message
        let buildParams = BuildTriggerParams(
            branch: params.branch,
            workflowId: params.workflow,
            commitMessage: commitMessage
        )
        guard !isLoading else { return }
        isLoading = true
        Task {
            do {
                _ = try await dependencies.apiFactory
                    .api(BuildsAPI.self)
                    .buildTrigger(appSlug: app.slug, buildParams: buildParams)
                dependencies.navigator.dismiss()
            } catch {
                onError(error)
            }
            isLoading = false
        }
    }
}
