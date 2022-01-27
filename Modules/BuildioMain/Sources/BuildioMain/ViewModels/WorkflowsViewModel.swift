//
//  WorkflowsViewModel.swift
//  
//
//  Created by Sergey Khliustin on 25.01.2022.
//

import Foundation
import BitriseAPIs
import Models

final class WorkflowsViewModel: BaseApiViewModel<[String]> {
    private let app: V0AppResponseItemModel
    
    override class var shouldRefreshOnInit: Bool {
        return true
    }
    
    init(_ tokenManager: TokenManager, app: V0AppResponseItemModel) {
        self.app = app
        super.init(tokenManager)
    }
    
    override func fetch() async throws -> [String] {
        try await apiFactory.api(BuildsAPI.self).buildWorkflowList(appSlug: app.slug).data ?? []
    }
}
