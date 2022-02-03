//
//  NewBuildViewModel.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 08.11.2021.
//

import Foundation
import Models
import Combine
import BitriseAPIs

public struct NewBuildViewModelParams {
    var appSlug: String
    var branch: String
    var workflow: String
    var message: String
    
    public init(appSlug: String, branch: String, workflow: String, message: String) {
        self.appSlug = appSlug
        self.branch = branch
        self.workflow = workflow
        self.message = message
    }
}

public final class NewBuildViewModel: BaseApiViewModel<V0BuildTriggerRespModel> {
    public var params: NewBuildViewModelParams!
    
    override func fetch() async throws -> V0BuildTriggerRespModel {
        let buildParams = BuildTriggerParams(branch: params.branch, workflowId: params.workflow, commitMessage: params.message)
        return try await apiFactory.api(BuildsAPI.self).buildTrigger(appSlug: params.appSlug, buildParams: buildParams)
    }
}
