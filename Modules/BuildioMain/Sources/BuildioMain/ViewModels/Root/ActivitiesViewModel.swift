//
//  ActivitiesViewModel.swift
//  Buildio
//
//  Created by Sergey Khliustin on 03.11.2021.
//

import Foundation
import Models
import Combine
import BitriseAPIs

final class ActivitiesViewModel: RootPagingViewModel<V0ActivityEventListResponseModel>, RootViewModel {
    private let fetchLimit: Int = 10
    
    deinit {
        logger.debug("")
    }
    
    override func fetch() -> AnyPublisher<V0ActivityEventListResponseModel, ErrorResponse> {
        apiFactory
            .api(ActivityAPI.self)
            .activityList(limit: fetchLimit)
            .eraseToAnyPublisher()
    }
    
    override func fetchPage(next: String?) -> AnyPublisher<PagingViewModel<V0ActivityEventListResponseModel>.ValueType, ErrorResponse> {
        apiFactory
            .api(ActivityAPI.self)
            .activityList(next: next, limit: fetchLimit)
            .eraseToAnyPublisher()
    }
}
