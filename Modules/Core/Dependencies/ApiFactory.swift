//
//  ApiFactory.swift
//  Modules
//
//  Created by Sergii Khliustin on 03.11.2024.
//

import API

package struct ApiFactory: Sendable {
    package let token: String?
    
    package init(token: String?) {
        self.token = token
    }
    
    package func api<T: BaseAPI>(_ type: T.Type) -> T {
        return T(apiToken: token)
    }
}
