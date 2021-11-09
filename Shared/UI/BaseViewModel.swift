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
    case error
}

protocol BaseViewModelProtocol: ObservableObject {
    associatedtype ValueType
    associatedtype ParamsType
    var value: ValueType? { get }
    var state: BaseViewModelState { get }
    var error: ErrorResponse? { get }
    func fetch(params: ParamsType) -> AnyPublisher<ValueType, ErrorResponse>
    func refresh(params: ParamsType)
    func beforeRefresh()
    func afterRefresh()
}

class ParamsBaseViewModel<ValueType, ParamsType>: BaseViewModelProtocol {
    @Published var value: ValueType?
    @Published var state: BaseViewModelState = .idle
    @Published var error: ErrorResponse?
    
    var fetcher: AnyCancellable?
    var tokenRefresher: AnyCancellable?
    
    var errorString: String? {
        if case .error = state {
            return error?.rawErrorString
        } else {
            return nil
        }
    }
    
    func fetch(params: ParamsType) -> AnyPublisher<ValueType, ErrorResponse> {
        fatalError("Should override")
    }
    
    func beforeRefresh() {
        
    }
    
    func refresh(params: ParamsType) {
        beforeRefresh()
        fetcher?.cancel()
        
        state = .loading
        
        fetcher = fetch(params: params)
            .sink(receiveCompletion: { [weak self] subscriberCompletion in
                guard let self = self else { return }
                if case .failure(let error) = subscriberCompletion {
                    self.error = error
                    self.state = .error
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
                        self?.refresh(params: params)
                    }
                }
        }
    }
    
    func afterRefresh() {
        
    }
}

class BaseViewModel<ValueType>: BaseViewModelProtocol {
    typealias ParamsType = Any?
    
    @Published var value: ValueType?
    @Published var state: BaseViewModelState = .idle
    @Published var error: ErrorResponse?
    
    var fetcher: AnyCancellable?
    var tokenRefresher: AnyCancellable?
    
    var errorString: String? {
        if case .error = state {
            return error?.rawErrorString
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
    
    func fetch(params: ParamsType) -> AnyPublisher<ValueType, ErrorResponse> {
        fatalError("Should override")
    }
    
    func beforeRefresh() {
        
    }
    
    func refresh() {
        refresh(params: nil)
    }
    
    func refresh(params: ParamsType) {
        beforeRefresh()
        fetcher?.cancel()
        
        state = .loading
        
        fetcher = fetch(params: params)
            .sink(receiveCompletion: { [weak self] subscriberCompletion in
                guard let self = self else { return }
                if case .failure(let error) = subscriberCompletion {
                    self.error = error
                    self.state = .error
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
