//
//  AppsViewModel.swift
//  Buildio
//
//  Created by severehed on 28.10.2021.
//

import Foundation
import Models
import Combine

final class AppsViewModel: PagingViewModel {
    @Published var state: BaseViewModelState<[V0AppResponseItemModel]> = .idle
    @Published var pagingState: PagingState = .idle
    var tokenRefresher: AnyCancellable?
    private let fetchLimit: Int = 10
    
    init() {
        refresh()
    }
    
    func fetch() -> AnyPublisher<[V0AppResponseItemModel], ErrorResponse> {
        ApplicationAPI()
            .appList(limit: fetchLimit)
            .map({ $0.data })
            .eraseToAnyPublisher()
    }
    
    func fetchNextPage() -> AnyPublisher<[V0AppResponseItemModel], ErrorResponse> {
        ApplicationAPI()
            .appList(next: self.value?.last?.slug, limit: fetchLimit)
            .map({ $0.data })
            .eraseToAnyPublisher()
    }
    
    func merge(value: [V0AppResponseItemModel]?, newValue: [V0AppResponseItemModel]) -> ([V0AppResponseItemModel], Bool) {
        guard let value = value else {
            return (newValue, true)
        }
        let result = value + newValue.dropFirst()
        return (result, newValue.count != 1)
    }
}
