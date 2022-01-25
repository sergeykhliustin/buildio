//
//  BaseAPI.swift
//  Buildio
//
//  Created by Sergey Khliustin on 27.10.2021.
//
import Foundation

public class BaseAPI {
    
    public var requestBuilderFactory: RequestBuilderFactory {
        if let apiToken = self.apiToken {
            if apiToken == "demo" {
                return DemoRequestBuilderFactory()
            } else if ProcessInfo.processInfo.environment["DEMO_RECORD"] != nil {
                return DemoRequestBuilderFactory()
            } else {
                return URLSessionRequestBuilderFactory()
            }
        } else {
            return NoApiKeyRequestBuilderFactory()
        }
    }
    
    let apiToken: String?
    
    public required init(apiToken: String?) {
        self.apiToken = apiToken
    }
    
    func authorizationHeaders() -> [String: Any?] {
        return ["Authorization": apiToken]
    }
}
