//
//  ArtifactsViewModel.swift
//  
//
//  Created by Sergey Khliustin on 30.11.2021.
//

import Foundation
import Models
import Combine
import BitriseAPIs

final class ArtifactsViewModel: PagingViewModel<V0ArtifactListResponseModel> {
    private let fetchLimit: Int = 10
    private let build: BuildResponseItemModel
    
    override class var shouldRefreshOnInit: Bool {
        return true
    }
    
    override class var shouldRefreshAfterBackground: Bool {
        return true
    }
    
    init(build: BuildResponseItemModel) {
        self.build = build
        super.init()
    }
    
    override func fetch() -> AnyPublisher<V0ArtifactListResponseModel, ErrorResponse> {
        return BuildArtifactAPI().artifactList(appSlug: build.repository.slug, buildSlug: build.slug, limit: fetchLimit).eraseToAnyPublisher()
    }
    
    override func fetchPage(next: String?) -> AnyPublisher<V0ArtifactListResponseModel, ErrorResponse> {
        return BuildArtifactAPI().artifactList(appSlug: build.repository.slug, buildSlug: build.slug, next: next, limit: fetchLimit).eraseToAnyPublisher()
    }
}
