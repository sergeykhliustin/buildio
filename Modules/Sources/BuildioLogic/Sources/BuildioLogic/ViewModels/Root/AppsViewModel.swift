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

public final class AppsViewModel: RootPagingViewModel<V0AppListResponseModel>, RootViewModel {
    private let fetchLimit: Int = 10
    private var origItems: [V0AppResponseItemModel] = []
    @Published public var searchText = ""
    private var searchFetcher: AnyCancellable?
    
    override class var shouldHandleActivityUpdates: Bool {
        return false
    }
    
    public override init(_ tokenManager: TokenManager) {
        super.init(tokenManager)
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
    
    public override func afterRefresh() {
        super.afterRefresh()
        origItems.removeAll()
    }
    
    override func fetch() async throws -> V0AppListResponseModel {
        try await apiFactory.api(ApplicationAPI.self).appList(title: searchText, sortBy: .lastBuildAt, limit: fetchLimit)
    }
    
    override func fetchPage(next: String?) async throws -> PagingViewModel<V0AppListResponseModel>.ValueType {
        try await apiFactory.api(ApplicationAPI.self).appList(title: searchText, sortBy: .lastBuildAt, next: next, limit: fetchLimit)
    }
}
