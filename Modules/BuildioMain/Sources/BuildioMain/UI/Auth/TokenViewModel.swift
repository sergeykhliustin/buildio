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
    
    override func fetch() -> AnyPublisher<V0UserProfileRespModel, ErrorResponse> {
        return UserAPI(apiToken: token)
            .userProfile()
    }
}
