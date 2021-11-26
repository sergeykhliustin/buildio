//
//  UserDefaults.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 18.11.2021.
//

import Foundation

extension UserDefaults {
    var lastActivitySlug: String? {
        get {
            self.string(forKey: "last_activity_slug")
        }
        set {
            self.set(newValue, forKey: "last_activity_slug")
            self.synchronize()
        }
    }
}
