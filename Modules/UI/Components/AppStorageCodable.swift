//
//  AppStorageCodable.swift
//  Modules
//
//  Created by Sergii Khliustin on 08.11.2024.
//

import Foundation
import SwiftUI

@propertyWrapper
package struct AppStorageCodable<T: Codable>: DynamicProperty {
    private let key: String
    private let defaultValue: T
    @AppStorage private var data: Data?

    package init(wrappedValue: T, _ key: String) {
        self.key = key
        self.defaultValue = wrappedValue
        self._data = AppStorage(key)
    }

    package var wrappedValue: T {
        get {
            if let data = data {
                let decodedValue = try? JSONDecoder().decode(T.self, from: data)
                return decodedValue ?? defaultValue
            }
            return defaultValue
        }
        set {
            data = try? JSONEncoder().encode(newValue)
        }
    }
}
