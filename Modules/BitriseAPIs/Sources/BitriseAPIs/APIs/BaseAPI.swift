//
//  BaseAPI.swift
//  Buildio
//
//  Created by Sergey Khliustin on 27.10.2021.
//

public class BaseAPI {
    public static var defaultApiToken: (() -> String?)!
    
    let apiToken: String?
    
    public init() {
        self.apiToken = BaseAPI.defaultApiToken()
    }
    
    public init(apiToken: String?) {
        self.apiToken = apiToken
    }
    
    func authorizationHeaders() -> [String: Any?] {
        return ["Authorization": apiToken]
    }
}
