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

@MainActor
protocol RootViewModel {
    init(_ tokenManager: TokenManager)
}

protocol CacheableViewModel {

}

@MainActor
protocol BaseViewModelProtocol: ObservableObject {
    associatedtype ValueType
    var value: ValueType? { get }
    var state: BaseViewModelState { get }
    var error: ErrorResponse? { get }
    var isScrollViewRefreshing: Binding<Bool> { get }
    var isTopIndicatorRefreshing: Binding<Bool> { get }
    
    static var shouldRefreshOnInit: Bool { get }
    static var shouldHandleActivityUpdates: Bool { get }
    static var shouldRefreshAfterBackground: Bool { get }
    
    var shouldHandleActivityUpdate: Bool { get }
    var shouldRefreshAfterBackground: Bool { get }
    
    func fetch() async throws -> ValueType
    func refresh()
    func beforeRefresh()
    func afterRefresh()
}

class BaseViewModel<ValueType>: BaseViewModelProtocol {
    
    @Published var value: ValueType?
    @Published var state: BaseViewModelState = .idle
    @Published var error: ErrorResponse?
    
    private var fetcher: Task<Void, Never>?
    
    private var activityWatcher: AnyCancellable?
    private var backgroundUpdater: AnyCancellable?
    
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
        return false
    }
    
    class var shouldHandleActivityUpdates: Bool {
        return false
    }
    
    class var shouldRefreshAfterBackground: Bool {
        return false
    }
    
    var shouldHandleActivityUpdate: Bool {
        return Self.shouldHandleActivityUpdates
    }
    
    var shouldRefreshAfterBackground: Bool {
        return Self.shouldRefreshAfterBackground
    }
    
    init() {
        if Self.shouldRefreshOnInit {
            DispatchQueue.main.async {
                self.refresh()
            }
        }
        
        if Self.shouldHandleActivityUpdates {
            activityWatcher = NotificationCenter.default.publisher(for: ActivityWatcher.lastActivityDateUpdated).sink { [weak self] notification in
                guard let self = self, let date = notification.object as? Date else { return }
                if self.state == .value {
                    if let lastRefreshDate = self.lastRefreshDate, lastRefreshDate < date {
                        if self.shouldHandleActivityUpdate {
                            self.refresh()
                        }
                    }
                } else if self.state == .error {
                    if self.shouldHandleActivityUpdate {
                        self.refresh()
                    }
                }
            }
        }
        
        if Self.shouldRefreshAfterBackground {
            backgroundUpdater = NotificationCenter.default
                .publisher(for: UIApplication.didBecomeActiveNotification)
                .sink(receiveValue: { [weak self] _ in
                    guard let self = self else { return }
                    if self.shouldRefreshAfterBackground {
                        self.refresh()
                    }
                })
        }
    }
    
    func fetch() async throws -> ValueType {
        fatalError("Should override")
    }
    
    func beforeRefresh() {
        refreshStarted = Date()
    }
    
    func refresh() {
        beforeRefresh()
        
        fetcher?.cancel()
        
        state = .loading
        fetcher = Task {
            do {
                self.value = try await fetch()
                self.state = .value
            } catch {
                self.error = error as? ErrorResponse
                self.state = .error
            }
            self.afterRefresh()
        }
    }
    
    func afterRefresh() {
        if state != .error {
            lastRefreshDate = refreshStarted
        }
    }
}
