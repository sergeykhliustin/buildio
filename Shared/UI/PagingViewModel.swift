//
//  PagingViewModel.swift
//  Buildio
//
//  Created by severehed on 24.10.2021.
//

import Foundation
import Combine
import Models

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

protocol PagingViewModelProtocol: BaseViewModelProtocol where ValueType: PagingResponseModel {
    var pagingState: PagingState { get set }
    var items: [ValueType.ItemType] { get set }
    
    func merge(value: [ValueType.ItemType]?, newValue: [ValueType.ItemType]) -> [ValueType.ItemType]
    func fetchPage(next: String?) -> AnyPublisher<ValueType, ErrorResponse>
}

class PagingViewModel<VALUE: PagingResponseModel>: BaseViewModel<VALUE>, PagingViewModelProtocol {
    
    @Published var pagingState: PagingState = .idle
    @Published var items: [ValueType.ItemType] = []
    private var pageFetcher: AnyCancellable?
    
    override func beforeRefresh() {
        super.beforeRefresh()
        pagingState = .idle
    }
    
    override func afterRefresh() {
        super.afterRefresh()
        items = value?.data ?? []
    }
    
    func nextPage() {
        guard case .value = state else { return }
        guard pagingState.canLoadNext else { return }
        pagingState = .loading
        
        pageFetcher = fetchPage(next: value?.paging.next)
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
                let items = self.merge(value: self.value?.data, newValue: value.data)
                self.items = items
                self.value = value
                if value.paging.next == nil {
                    self.pagingState = .last
                }
            }
    }
    
    func merge(value: [ValueType.ItemType]?, newValue: [ValueType.ItemType]) -> [ValueType.ItemType] {
        guard let value = value else {
            return newValue
        }
        
        return value + newValue
    }
    
    func fetchPage(next: String?) -> AnyPublisher<ValueType, ErrorResponse> {
        fatalError("Should be overridden")
    }
}
