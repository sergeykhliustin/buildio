//
//  AppsViewModel.swift
//  Buildio
//
//  Created by Sergey Khliustin on 28.10.2021.
//

import Foundation
import Models
import Combine

final class AppsViewModel: PagingViewModel<V0AppListResponseModel>, ResolvableViewModel {
    private let fetchLimit: Int = 10
    
    override func fetch(params: Any?) -> AnyPublisher<V0AppListResponseModel, ErrorResponse> {
        ApplicationAPI()
            .appList(sortBy: .lastBuildAt, limit: fetchLimit)
            .eraseToAnyPublisher()
    }
    
    override func fetchPage(next: String?) -> AnyPublisher<PagingViewModel<V0AppListResponseModel>.ValueType, ErrorResponse> {
        ApplicationAPI()
            .appList(sortBy: .lastBuildAt, next: next, limit: fetchLimit)
            .eraseToAnyPublisher()
    }
}
