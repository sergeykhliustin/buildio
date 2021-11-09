//
//  NewBuildViewModel.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 08.11.2021.
//

import Foundation
import Models
import Combine

struct NewBuildViewModelParams {
    var appSlug: String
    var branch: String
    var workflow: String
    var message: String
}

final class NewBuildViewModel: ParamsBaseViewModel<V0BuildTriggerRespModel, NewBuildViewModelParams> {
    
    override func fetch(params: NewBuildViewModelParams) -> AnyPublisher<V0BuildTriggerRespModel, ErrorResponse> {
        let buildParams = V0BuildTriggerParams(buildParams: V0BuildTriggerParamsBuildParams(branch: params.branch, workflow: params.workflow, message: params.message.isEmpty ? nil : params.message), hookInfo: V0BuildTriggerParamsHookInfo())
        return BuildsAPI().buildTrigger(appSlug: params.appSlug, buildParams: buildParams)
    }
}
