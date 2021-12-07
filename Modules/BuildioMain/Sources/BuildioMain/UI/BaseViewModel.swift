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
    var isScrollViewRefreshing: Binding<Bool> { get }
    var isTopIndicatorRefreshing: Binding<Bool> { get }
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
    var isScrollViewRefreshing: Binding<Bool> {
        return Binding(get: { self.state == .loading && self.value == nil }, set: { _ in })
    }
    
    var isTopIndicatorRefreshing: Binding<Bool> {
        return Binding(get: { self.state == .loading && self.value != nil }, set: { _ in })
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
    
    private var fetcher: AnyCancellable?
    private var tokenRefresher: AnyCancellable?
    
    private var tokenUpdated: Bool = false
    
    private var activityWatcher: AnyCancellable?
    
    private var refreshStarted: Date?
    private var lastRefreshDate: Date?
    
    var isScrollViewRefreshing: Binding<Bool> {
        return Binding(get: { self.state == .loading && self.value == nil }, set: { _ in self.refresh() })
    }
    
    var isTopIndicatorRefreshing: Binding<Bool> {
        return Binding(get: { self.state == .loading && self.value != nil }, set: { _ in })
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
    
    class var shouldAutoUpdate: Bool {
        return false
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
        
        if Self.shouldAutoUpdate {
            activityWatcher = ActivityWatcher.shared.$lastActivityDate.sink { [weak self] date in
                guard let self = self else { return }
                if self.state == .value {
                    if let lastRefreshDate = self.lastRefreshDate, lastRefreshDate < date {
                        self.refresh()
                    }
                } else if self.state == .error {
                    self.refresh()
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
        refreshStarted = Date()
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
        if state != .error {
            lastRefreshDate = refreshStarted
        }
    }
}
