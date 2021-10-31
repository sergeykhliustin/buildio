//
//  BuildsViewModel.swift
//  Buildio
//
//  Created by severehed on 01.10.2021.
//

import Foundation
import Models
import Combine

class BuildsViewModel: PagingViewModel<V0BuildListResponseModel> {
    private let fetchLimit: Int = 10
    private var app: V0AppResponseItemModel?
    
    init(app: V0AppResponseItemModel? = nil) {
        self.app = app
        super.init()
    }
    
    override func fetch() -> AnyPublisher<V0BuildListResponseModel, ErrorResponse> {
        if let app = app {
            return BuildsAPI().buildList(appSlug: app.slug, limit: fetchLimit)
                .eraseToAnyPublisher()
        }
        return BuildsAPI().buildListAll(limit: fetchLimit)
            .eraseToAnyPublisher()
    }
    
    override func fetchNextPage() -> AnyPublisher<V0BuildListResponseModel, ErrorResponse> {
        if let app = app {
            return BuildsAPI().buildList(appSlug: app.slug, limit: fetchLimit)
                .eraseToAnyPublisher()
        }
        return BuildsAPI().buildListAll(next: self.items.last?.slug, limit: fetchLimit)
            .eraseToAnyPublisher()
    }
    
    override func merge(value: [V0BuildResponseItemModel]?, newValue: [V0BuildResponseItemModel]) -> ([V0BuildResponseItemModel], Bool) {
        guard let value = value else {
            return (newValue, true)
        }
        
        let result = value + newValue.dropFirst()
        
        return (result, newValue.count != 1)
    }
}
