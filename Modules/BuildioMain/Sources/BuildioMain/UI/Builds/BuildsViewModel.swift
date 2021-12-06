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

final class BuildsViewModel: PagingViewModel<V0BuildListResponseModel>, ResolvableViewModel {
    private let fetchLimit: Int = 10
    private(set) var app: V0AppResponseItemModel?
    
    private var activityWatcher: AnyCancellable?
    private var lastRefreshDate: Date?
    
    deinit {
        logger.debug("")
    }
    
    override init() {
        super.init()
        activityWatcher = ActivityWatcher.shared.$lastActivityDate.sink { [weak self] date in
            guard let self = self else { return }
            if self.state == .value {
                if let lastRefreshDate = self.lastRefreshDate, lastRefreshDate < date {
                    self.refresh()
                }
            }
        }
    }
    
    convenience init(app: V0AppResponseItemModel? = nil) {
        self.init()
        self.app = app
    }
    
    override func beforeRefresh(_ tokenUpdated: Bool) {
        super.beforeRefresh(tokenUpdated)
        lastRefreshDate = Date()
    }
    
    override func fetch(params: Any?) -> AnyPublisher<V0BuildListResponseModel, ErrorResponse> {
        if let app = app {
            let enrich = self.enrich
            return BuildsAPI().buildList(appSlug: app.slug, limit: fetchLimit)
                .map({ enrich($0, app) })
                .eraseToAnyPublisher()
        }
        return BuildsAPI().buildListAll(limit: fetchLimit)
            .eraseToAnyPublisher()
    }
    
    override func fetchPage(next: String?) -> AnyPublisher<PagingViewModel<V0BuildListResponseModel>.ValueType, ErrorResponse> {
        if let app = app {
            let enrich = self.enrich
            return BuildsAPI().buildList(appSlug: app.slug, sortBy: .runningFirst, next: next, limit: fetchLimit)
                .map({ enrich($0, app) })
                .eraseToAnyPublisher()
        }
        return BuildsAPI().buildListAll(next: next, limit: fetchLimit)
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
