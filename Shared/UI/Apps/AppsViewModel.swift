//
//  AppsViewModel.swift
//  Buildio
//
//  Created by severehed on 28.10.2021.
//

import Foundation
import Models
import Combine

final class AppsViewModel: PagingViewModel<V0AppListResponseModel> {
    private let fetchLimit: Int = 10
    
    override func fetch() -> AnyPublisher<V0AppListResponseModel, ErrorResponse> {
        ApplicationAPI()
            .appList(limit: fetchLimit)
            .eraseToAnyPublisher()
    }
    
    override func fetchPage(next: String?) -> AnyPublisher<PagingViewModel<V0AppListResponseModel>.ValueType, ErrorResponse> {
        ApplicationAPI()
            .appList(next: next, limit: fetchLimit)
            .eraseToAnyPublisher()
    }
}
