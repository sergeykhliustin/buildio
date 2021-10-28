//
//  BuildsViewModel.swift
//  Buildio
//
//  Created by severehed on 01.10.2021.
//

import Foundation
import Models
import Combine

class BuildsViewModel: PagingViewModel {
    
    @Published var state: BaseViewModelState<[V0BuildListAllResponseItemModel]> = .idle
    @Published var pagingState: PagingState = .idle {
        didSet {
            if case .last = pagingState {
                logger.debug("last page")
            }
        }
    }
    
    var tokenRefresher: AnyCancellable?
    
    private let fetchLimit: Int = 10
    
    init() {
        refresh()
    }
    
    func fetch() -> AnyPublisher<[V0BuildListAllResponseItemModel], ErrorResponse> {
        BuildsAPI().buildListAll(limit: fetchLimit)
            .map({ $0.data })
            .eraseToAnyPublisher()
    }
    
    func fetchNextPage() -> AnyPublisher<[V0BuildListAllResponseItemModel], ErrorResponse> {
        BuildsAPI().buildListAll(next: self.value?.last?.slug, limit: fetchLimit)
            .map({ $0.data })
            .eraseToAnyPublisher()
    }
    
    func merge(value: [V0BuildListAllResponseItemModel]?, newValue: [V0BuildListAllResponseItemModel]) -> ([V0BuildListAllResponseItemModel], Bool) {
        guard let value = value else {
            return (newValue, true)
        }
        
        let result = value + newValue.dropFirst()
        
        return (result, newValue.count != 1)
    }
}
