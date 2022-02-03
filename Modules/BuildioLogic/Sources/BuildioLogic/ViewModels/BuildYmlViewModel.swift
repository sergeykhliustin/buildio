//
//  BuildYmlViewModel.swift
//  
//
//  Created by Sergey Khliustin on 02.02.2022.
//

import Models
import BitriseAPIs

public final class BuildYmlViewModel: BaseApiViewModel<String> {
    public let build: BuildResponseItemModel
    
    override class var shouldRefreshOnInit: Bool {
        return true
    }
    
    init(_ tokenManager: TokenManager, build: BuildResponseItemModel) {
        self.build = build
        super.init(tokenManager)
    }
    
    override func fetch() async throws -> String {
        try await apiFactory.api(BuildsAPI.self).buildBitriseYmlShow(appSlug: build.repository.slug, buildSlug: build.slug)
    }
}
