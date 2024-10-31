//
//  ProcessInfo.swift
//  
//
//  Created by Sergey Khliustin on 05.12.2022.
//

import Foundation

public extension ProcessInfo {
    enum Keys: String {
        case OverrideInterfaceStyle
        case TestsMode
    }
    var env: [Keys: String] {
        return environment.reduce([Keys: String]()) { result, element in
            var result = result
            if let key = Keys(rawValue: element.key) {
                result[key] = element.value
            }
            return result
        }
    }

    var isTestEnv: Bool {
        return env[.TestsMode] != nil
    }
}
