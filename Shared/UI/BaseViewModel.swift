//
//  BaseViewModel.swift
//  Buildio
//
//  Created by Sergey Khliustin on 01.10.2021.
//

import Foundation
import Combine

public enum BaseViewModelState {
    case idle
    case loading
    case value
    case error(ErrorResponse)
}

protocol BaseViewModelProtocol: ObservableObject {
    associatedtype ValueType
    var value: ValueType? { get }
    var state: BaseViewModelState { get }
    func fetch() -> AnyPublisher<ValueType, ErrorResponse>
    func refresh()
    func beforeRefresh()
    func afterRefresh()
}

class BaseViewModel<ValueType>: BaseViewModelProtocol {
    @Published var value: ValueType?
    @Published var state: BaseViewModelState = .idle
    
    var fetcher: AnyCancellable?
    var tokenRefresher: AnyCancellable?
    
    var error: String? {
        if case .error(let error) = state {
            return error.rawErrorString
        } else {
            return nil
        }
    }
    
    class var shouldRefreshOnInit: Bool {
        return true
    }
    
    init() {
        if Self.shouldRefreshOnInit {
            refresh()
        }
    }
    
    func fetch() -> AnyPublisher<ValueType, ErrorResponse> {
        fatalError("Should override")
    }
    
    func beforeRefresh() {
        
    }
    
    func refresh() {
        beforeRefresh()
        fetcher?.cancel()
        
        state = .loading
        
        fetcher = fetch()
            .sink(receiveCompletion: { [weak self] subscriberCompletion in
                guard let self = self else { return }
                if case .failure(let error) = subscriberCompletion {
                    self.state = .error(error)
                }
                self.afterRefresh()
            }, receiveValue: { [weak self] value in
                guard let self = self else { return }
                self.value = value
                self.state = .value
            })
        
        if tokenRefresher == nil {
            tokenRefresher = TokenManager.shared.$token
                .dropFirst()
                .sink { [weak self] value in
                    DispatchQueue.main.async {
                        self?.refresh()
                    }
                }
        }
    }
    
    func afterRefresh() {
        
    }
}
