//
//  BranchesViewModel.swift
//  
//
//  Created by Sergey Khliustin on 25.01.2022.
//

import Models
import Combine
import BitriseAPIs

public final class BranchesViewModel: BaseApiViewModel<[String]> {
    let app: V0AppResponseItemModel
    
    override class var shouldRefreshOnInit: Bool {
        return true
    }
    
    init(_ tokenManager: TokenManager, app: V0AppResponseItemModel) {
        self.app = app
        super.init(tokenManager)
    }
    
    override func fetch() async throws -> [String] {
        try await apiFactory.api(ApplicationAPI.self).branchList(appSlug: app.slug).data ?? []
    }
}
