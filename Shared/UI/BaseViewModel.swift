//
//  BaseViewModel.swift
//  Buildio
//
//  Created by severehed on 01.10.2021.
//

import Foundation
import Combine

enum BaseViewModelState<T> {
    case idle
    case loading(AnyCancellable)
    case value(T)
    case error(Error?)
}

protocol BaseViewModel: ObservableObject {
    associatedtype VALUE
    
    var state: BaseViewModelState<VALUE> { get set }
    var tokenRefresher: AnyCancellable? { get set }
    
    func fetch() -> AnyPublisher<VALUE, Error>
    
    func refresh()
    
    func beforeRefresh()
}

extension BaseViewModel {
    var isLoading: Bool {
        if case .loading(_) = state {
            return true
        }
        return false
    }
    var value: VALUE? {
        if case .value(let value) = state {
            return value
        }
        return nil
    }
    
    func refresh() {
        beforeRefresh()
        if case .loading(let fetcher) = state {
            fetcher.cancel()
        }
        
        let fetcher = fetch()
            .sink(receiveCompletion: { [weak self] subscriberCompletion in
                guard let self = self else { return }
                if case .failure(let error) = subscriberCompletion {
                    self.state = .error(error)
                }
            }, receiveValue: { [weak self] value in
                guard let self = self else { return }
                self.state = .value(value)
            })
        state = .loading(fetcher)
        
        if tokenRefresher == nil {
            tokenRefresher = TokenManager.shared.$token
                .dropFirst()
                .sink { [weak self] value in
                    self?.refresh()
                }
        }
    }
}
