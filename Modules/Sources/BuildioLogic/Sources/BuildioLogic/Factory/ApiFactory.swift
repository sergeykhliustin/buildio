//
//  ApiFactory.swift
//  
//
//  Created by Sergey Khliustin on 25.01.2022.
//

import Foundation
import BitriseAPIs

final class ApiFactory {
    private let token: () -> String?
    
    init(token: @autoclosure @escaping () -> String?) {
        self.token = token
    }
    
    func api<T: BaseAPI>(_ type: T.Type) -> T {
        return T(apiToken: token())
    }
}
