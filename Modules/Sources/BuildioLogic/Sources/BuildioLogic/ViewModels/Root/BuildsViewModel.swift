//
//  BuildsViewModel.swift
//  Buildio
//
//  Created by Sergey Khliustin on 01.10.2021.
//

import Foundation
import Models
import Combine
import BitriseAPIs

public final class BuildsViewModel: RootPagingViewModel<V0BuildListResponseModel>, RootViewModel {
    
    private let fetchLimit: Int = 10
    public private(set) var app: V0AppResponseItemModel?
    
    deinit {
        logger.debug("")
    }
    
    public override init(_ tokenManager: TokenManager) {
        super.init(tokenManager)
    }
    
    convenience init(_ tokenManager: TokenManager, app: V0AppResponseItemModel?) {
        self.init(tokenManager)
        self.app = app
    }
    
    override func fetch() async throws -> V0BuildListResponseModel {
        let api = apiFactory.api(BuildsAPI.self)
        if let app = app {
            let list = try await api.buildList(appSlug: app.slug, sortBy: .runningFirst, limit: fetchLimit)
            return enrich(list, app: app)
        } else {
            return try await api.buildListAll(limit: fetchLimit)
        }
    }
    
    override func fetchPage(next: String?) async throws -> PagingViewModel<V0BuildListResponseModel>.ValueType {
        let api = apiFactory.api(BuildsAPI.self)
        if let app = app {
            let list = try await api.buildList(appSlug: app.slug, sortBy: .runningFirst, next: next, limit: fetchLimit)
            return enrich(list, app: app)
        } else {
            return try await api.buildListAll(next: next, limit: fetchLimit)
        }
    }
    
    private func enrich(_ model: V0BuildListResponseModel, app: V0AppResponseItemModel) -> V0BuildListResponseModel {
        var model = model
        let data = model.data.reduce([BuildResponseItemModel]()) { partialResult, item in
            var partialResult = partialResult
            var item = item
            item.repository = app
            partialResult.append(item)
            return partialResult
        }
        model.data = data
        return model
    }
}
