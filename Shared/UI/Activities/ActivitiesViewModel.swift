//
//  ActivitiesViewModel.swift
//  Buildio
//
//  Created by Sergey Khliustin on 03.11.2021.
//

import Foundation
import Models
import Combine

final class ActivitiesViewModel: PagingViewModel<V0ActivityEventListResponseModel> {
    private let fetchLimit: Int = 10
    
    override func fetch(params: Any?) -> AnyPublisher<V0ActivityEventListResponseModel, ErrorResponse> {
        ActivityAPI().activityList(limit: fetchLimit)
            .eraseToAnyPublisher()
    }
    
    override func fetchPage(next: String?) -> AnyPublisher<PagingViewModel<V0ActivityEventListResponseModel>.ValueType, ErrorResponse> {
        ActivityAPI().activityList(next: next, limit: fetchLimit)
            .eraseToAnyPublisher()
    }
}
