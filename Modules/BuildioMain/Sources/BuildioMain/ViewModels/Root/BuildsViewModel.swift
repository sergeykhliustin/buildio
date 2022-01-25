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

final class BuildsViewModel: RootPagingViewModel<V0BuildListResponseModel>, RootViewModel {
    
    private let fetchLimit: Int = 10
    private(set) var app: V0AppResponseItemModel?
    
    deinit {
        logger.debug("")
    }
    
    convenience init(_ tokenManager: TokenManager, app: V0AppResponseItemModel?) {
        self.init(tokenManager)
        self.app = app
    }
    
    override func fetch() -> AnyPublisher<V0BuildListResponseModel, ErrorResponse> {
        let api = apiFactory.api(BuildsAPI.self)
        if let app = app {
            let enrich = self.enrich
            return api
                .buildList(appSlug: app.slug, limit: fetchLimit)
                .map({ enrich($0, app) })
                .eraseToAnyPublisher()
        }
        return api
            .buildListAll(limit: fetchLimit)
            .eraseToAnyPublisher()
    }
    
    override func fetchPage(next: String?) -> AnyPublisher<PagingViewModel<V0BuildListResponseModel>.ValueType, ErrorResponse> {
        let api = apiFactory.api(BuildsAPI.self)
        if let app = app {
            let enrich = self.enrich
            return api
                .buildList(appSlug: app.slug, sortBy: .runningFirst, next: next, limit: fetchLimit)
                .map({ enrich($0, app) })
                .eraseToAnyPublisher()
        }
        return api
            .buildListAll(next: next, limit: fetchLimit)
            .eraseToAnyPublisher()
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
