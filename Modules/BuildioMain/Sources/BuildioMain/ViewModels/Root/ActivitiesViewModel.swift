//
//  ActivitiesViewModel.swift
//  Buildio
//
//  Created by Sergey Khliustin on 03.11.2021.
//

import Models
import BitriseAPIs

final class ActivitiesViewModel: RootPagingViewModel<V0ActivityEventListResponseModel>, RootViewModel {
    private let fetchLimit: Int = 10
    
    deinit {
        logger.debug("")
    }
    
    override func fetch() async throws -> V0ActivityEventListResponseModel {
        try await apiFactory.api(ActivityAPI.self).activityList(limit: fetchLimit)
    }
    
    override func fetchPage(next: String?) async throws -> PagingViewModel<V0ActivityEventListResponseModel>.ValueType {
        try await apiFactory.api(ActivityAPI.self).activityList(next: next, limit: fetchLimit)
    }
}
