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

struct NewBuildViewModelParams {
    var appSlug: String
    var branch: String
    var workflow: String
    var message: String
}

final class NewBuildViewModel: ParamsBaseViewModel<V0BuildTriggerRespModel, NewBuildViewModelParams> {
    override func fetch(params: NewBuildViewModelParams) -> AnyPublisher<V0BuildTriggerRespModel, ErrorResponse> {
        let buildParams = BuildTriggerParams(branch: params.branch, workflowId: params.workflow, commitMessage: params.message)
        return BuildsAPI().buildTrigger(appSlug: params.appSlug, buildParams: buildParams)
    }
}
