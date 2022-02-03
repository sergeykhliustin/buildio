//
//  File.swift
//  
//
//  Created by Sergey Khliustin on 06.12.2021.
//

import Models
import Combine
import BitriseAPIs

public final class AuthScreenViewModel: BaseViewModel<V0UserProfileRespModel> {
    public var token: String?
    
    public override init() {
        super.init()
    }
    
    override func fetch() async throws -> V0UserProfileRespModel {
        try await UserAPI(apiToken: token).userProfile()
    }
}
