//
//  BaseViewModel.swift
//  Buildio
//
//  Created by Sergey Khliustin on 01.10.2021.
//

import Foundation
import Combine
import SwiftUI

public enum BaseViewModelState {
    case idle
    case loading
    case value
    case error
}

protocol ResolvableViewModel {
    init()
}

protocol CacheableViewModel {

}

protocol BaseViewModelProtocol: ObservableObject {
    associatedtype ValueType
    associatedtype ParamsType
    var value: ValueType? { get }
    var state: BaseViewModelState { get }
    var error: ErrorResponse? { get }
    var isRefreshing: Binding<Bool> { get }
    func fetch(params: ParamsType) -> AnyPublisher<ValueType, ErrorResponse>
    func refresh(params: ParamsType)
    func beforeRefresh(_ tokenUpdated: Bool)
    func afterRefresh()
}

class ParamsBaseViewModel<ValueType, ParamsType>: BaseViewModelProtocol {
    @Published var value: ValueType?
    @Published var state: BaseViewModelState = .idle
    @Published var error: ErrorResponse?
    
    var fetcher: AnyCancellable?
    var isRefreshing: Binding<Bool> {
        return Binding(get: { self.state == .loading }, set: { _ in })
    }
    
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
    
    func beforeRefresh(_ tokenUpdated: Bool) {
        if tokenUpdated {
            self.value = nil
        }
    }
    
    func refresh(params: ParamsType) {
        beforeRefresh(false)
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
    
    private var tokenUpdated: Bool = false
    
    var isRefreshing: Binding<Bool> {
        return Binding(get: { self.state == .loading }, set: { _ in self.refresh() })
    }
    
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
    
    class var shouldHandleTokenUpdates: Bool {
        return true
    }
    
    init() {
        if Self.shouldRefreshOnInit {
            refresh()
        }
        
        if Self.shouldHandleTokenUpdates {            
            tokenRefresher = TokenManager.shared.$token
                .dropFirst()
                .sink { [weak self] value in
                    DispatchQueue.main.async {
                        self?.tokenUpdated = true
                        self?.refresh()
                    }
                }
        }
    }
    
    func fetch(params: ParamsType) -> AnyPublisher<ValueType, ErrorResponse> {
        fatalError("Should override")
    }
    
    func beforeRefresh(_ tokenUpdated: Bool) {
        if tokenUpdated {
            self.value = nil
        }
    }
    
    func refresh() {
        refresh(params: nil)
    }
    
    func refresh(params: ParamsType) {
        beforeRefresh(tokenUpdated)
        tokenUpdated = false
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
    }
    
    func afterRefresh() {
        
    }
}
