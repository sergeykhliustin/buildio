//
//  AccountRowViewModel.swift
//  
//
//  Created by Sergey Khliustin on 03.02.2022.
//
import BitriseAPIs
import Models

public final class AccountRowViewModel: BaseViewModel<V0UserProfileDataModel> {
    let token: Token
    
    public init(token: Token) {
        self.token = token
        super.init()
    }
    
    override func fetch() async throws -> V0UserProfileDataModel {
        try await UserAPI(apiToken: token.token).userProfile().data
    }
}
