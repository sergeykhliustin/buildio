//
//  BaseAPI.swift
//  Buildio
//
//  Created by severehed on 27.10.2021.
//

public class BaseAPI {
    let apiToken: String?
    
    public init() {
        self.apiToken = TokenManager.shared.token?.token
    }
    
    public init(apiToken: String?) {
        self.apiToken = apiToken
    }
    
    func authorizationHeaders() -> [String: Any?] {
        return ["Authorization": apiToken]
    }
}