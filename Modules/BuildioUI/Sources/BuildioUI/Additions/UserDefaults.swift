//
//  UserDefaults.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 18.11.2021.
//

import Foundation

extension UserDefaults {
    var lastActivityDate: TimeInterval {
        get {
            self.double(forKey: "last_activity_date")
        }
        set {
            self.set(newValue, forKey: "last_activity_date")
            synchronize()
        }
    }
    
    func reset() {
        lastActivityDate = 0
    }
}
