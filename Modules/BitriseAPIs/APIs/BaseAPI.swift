//
//  BaseAPI.swift
//  Buildio
//
//  Created by Sergey Khliustin on 27.10.2021.
//
import Foundation

package class BaseAPI {
    
    package var requestBuilderFactory: RequestBuilderFactory {
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
    
    package required init(apiToken: String?) {
        self.apiToken = apiToken
    }
    
    func authorizationHeaders() -> [String: Any?] {
        return ["Authorization": apiToken]
    }
}
