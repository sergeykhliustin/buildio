//
//  UserDefaults.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 18.11.2021.
//

import Foundation

extension UserDefaults {
    func lastActivityDate(email: String) -> TimeInterval {
        if let double = dictionary(forKey: "last_activity_dates")?[email] as? Double {
            return double
        }
        return 0
    }
    
    func setLastActivityDate(_ date: TimeInterval, email: String) {
        lastActivityDates[email] = date
    }
    
    private var lastActivityDates: [String: Double] {
        get {
            dictionary(forKey: "last_activity_dates") as? [String: Double] ?? [:]
        }
        set {
            set(newValue, forKey: "last_activity_dates")
            synchronize()
        }
    }
    
    func reset() {
        lastActivityDates = [:]
    }
}
