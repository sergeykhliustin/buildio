//
//  File.swift
//  
//
//  Created by Sergey Khliustin on 06.12.2021.
//

import Models
import Combine
import BitriseAPIs

final class TokenViewModel: BaseViewModel<V0UserProfileRespModel> {
    var token: String?
    
    override class var shouldRefreshOnInit: Bool {
        return false
    }
    
    override class var shouldHandleTokenUpdates: Bool {
        return false
    }
    
    override func fetch(params: BaseViewModel<V0UserProfileRespModel>.ParamsType) -> AnyPublisher<V0UserProfileRespModel, ErrorResponse> {
        return UserAPI(apiToken: token)
            .userProfile()
    }
}
