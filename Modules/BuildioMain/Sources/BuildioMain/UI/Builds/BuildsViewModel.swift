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
    private var timer: Timer?
    
    deinit {
        logger.debug("")
    }
    
    override init() {
        super.init()
    }
    
    init(app: V0AppResponseItemModel? = nil) {
        self.app = app
        super.init()
    }
    
    override func afterRefresh() {
        super.afterRefresh()
        scheduleNextUpdate()
    }
    
    private func scheduleNextUpdate() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            self.refresh()
        })
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
