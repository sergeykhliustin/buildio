//
//  File.swift
//  
//
//  Created by Sergey Khliustin on 06.12.2021.
//

import Models
import Combine
import BitriseAPIs

final class AuthScreenViewModel: BaseViewModel<V0UserProfileRespModel> {
    var token: String?
    
    override func fetch() async throws -> V0UserProfileRespModel {
        try await UserAPI(apiToken: token).userProfile()
    }
}
