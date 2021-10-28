//
//  PagingViewModel.swift
//  Buildio
//
//  Created by severehed on 24.10.2021.
//

import Foundation
import Combine

enum PagingState {
    case loading(AnyCancellable)
    case error(ErrorResponse)
    case last
    case idle
    
    fileprivate var canLoadNext: Bool {
        if case .loading = self {
            return false
        } else if case .last = self {
            return false
        } else {
             return true
        }
    }
}

protocol PagingViewModel: BaseViewModel {
    var pagingState: PagingState { get set }
    func merge(value: VALUE?, newValue: VALUE) -> (VALUE, Bool)
    func fetchNextPage() -> AnyPublisher<VALUE, ErrorResponse>
}

extension PagingViewModel {
    var isLoadingPage: Bool {
        if case .loading = pagingState {
            return true
        }
        return false
    }
    
    func beforeRefresh() {
        pagingState = .idle
    }
    
    func nextPage() {
        guard case .value = state else { return }
        guard pagingState.canLoadNext else { return }
        
        let fetcher = fetchNextPage()
            .sink { [weak self] subscribersCompletion in
                guard let self = self else { return }
                if case .failure(let error) = subscribersCompletion {
                    self.pagingState = .error(error)
                } else if case .last = self.pagingState {
                    
                } else {
                    self.pagingState = .idle
                }
            } receiveValue: { [weak self] value in
                guard let self = self else { return }
                let (value, hasChanges) = self.merge(value: self.value, newValue: value)
                self.state = .value(value)
                if !hasChanges {
                    self.pagingState = .last
                }
            }
        pagingState = .loading(fetcher)
        
    }
}
