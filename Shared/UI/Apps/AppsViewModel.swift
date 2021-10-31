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
    
    override func fetchNextPage() -> AnyPublisher<V0AppListResponseModel, ErrorResponse> {
        ApplicationAPI()
            .appList(next: self.items.last?.slug, limit: fetchLimit)
            .eraseToAnyPublisher()
    }
    
    override func merge(value: [V0AppResponseItemModel]?, newValue: [V0AppResponseItemModel]) -> ([V0AppResponseItemModel], Bool) {
        guard let value = value else {
            return (newValue, true)
        }
        let result = value + newValue.dropFirst()
        return (result, newValue.count != 1)
    }
}
