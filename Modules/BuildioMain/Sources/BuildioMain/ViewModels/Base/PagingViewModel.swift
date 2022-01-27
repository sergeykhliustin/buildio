//
//  PagingViewModel.swift
//  Buildio
//
//  Created by Sergey Khliustin on 24.10.2021.
//

import Foundation
import Combine
import Models
import SwiftUI

enum PagingState {
    case loading
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

@MainActor
protocol PagingViewModelProtocol: BaseViewModelProtocol where ValueType: PagingResponseModel {
    var pagingState: PagingState { get set }
    var items: [ValueType.ItemType] { get set }
    
    func nextPage()
    func merge(value: [ValueType.ItemType]?, newValue: [ValueType.ItemType]) -> [ValueType.ItemType]
    func fetchPage(next: String?) async throws -> ValueType
}

@MainActor
class PagingViewModel<VALUE: PagingResponseModel>: BaseApiViewModel<VALUE>, PagingViewModelProtocol {
    
    @Published var pagingState: PagingState = .idle
    @Published var items: [ValueType.ItemType] = []
    private var pageFetcher: Task<Void, Never>?
    
    override func beforeRefresh(_ tokenUpdated: Bool) {
        super.beforeRefresh(tokenUpdated)
        if tokenUpdated {
            items = []
        }
        pagingState = .idle
    }
    
    override func afterRefresh() {
        super.afterRefresh()
        items = value?.data ?? []
        if value?.paging.next == nil {
            pagingState = .last
        }
    }
    
    func nextPage() {
        guard case .value = state else { return }
        guard pagingState.canLoadNext else { return }
        pagingState = .loading
        
        pageFetcher = Task {
            do {
                let value = try await fetchPage(next: value?.paging.next)
                self.items = merge(value: self.items, newValue: value.data)
                self.value = value
                if value.paging.next == nil {
                    pagingState = .last
                } else {
                    pagingState = .idle
                }
            } catch {
                self.pagingState = .error(error as! ErrorResponse)
            }
        }
    }
    
    func merge(value: [ValueType.ItemType]?, newValue: [ValueType.ItemType]) -> [ValueType.ItemType] {
        guard let value = value else {
            return newValue
        }
        
        return value + newValue
    }
    
    func fetchPage(next: String?) async throws -> ValueType {
        fatalError("Should be overridden")
    }
}
