//
//  AppsViewModel.swift
//  Buildio
//
//  Created by Sergey Khliustin on 28.10.2021.
//

import Foundation
import Models
import Combine
import SwiftUI
import BitriseAPIs

final class AppsViewModel: PagingViewModel<V0AppListResponseModel>, ResolvableViewModel {
    private let fetchLimit: Int = 10
    private var origItems: [V0AppResponseItemModel] = []
    @Published var searchText = ""
    private var searchFetcher: AnyCancellable?
    
    override init() {
        super.init()
        searchFetcher = $searchText
            .dropFirst()
            .sink { [weak self] newValue in
                if self?.searchLocal(newValue) != true {
                    self?.refresh()
                }
            }
    }
    
    func searchLocal(_ text: String) -> Bool {
        if let value = value, value.paging.next == nil {
            if origItems.isEmpty {
                origItems = items
            }
            if text.count > 0 {
                items = origItems.filter({ $0.title.contains(text.lowercased()) })
            } else {
                items = origItems
            }
            return true
        }
        return false
    }
    
    override func afterRefresh() {
        super.afterRefresh()
        origItems.removeAll()
    }
    
    override func fetch(params: Any?) -> AnyPublisher<V0AppListResponseModel, ErrorResponse> {
        ApplicationAPI()
            .appList(title: searchText, sortBy: .lastBuildAt, limit: fetchLimit)
            .eraseToAnyPublisher()
    }
    
    override func fetchPage(next: String?) -> AnyPublisher<PagingViewModel<V0AppListResponseModel>.ValueType, ErrorResponse> {
        ApplicationAPI()
            .appList(title: searchText, sortBy: .lastBuildAt, next: next, limit: fetchLimit)
            .eraseToAnyPublisher()
    }
}
