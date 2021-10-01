//
//  UserDefaults+Additions.swift
//  Buildio
//
//  Created by severehed on 01.10.2021.
//

import Foundation

extension UserDefaults {
    var token: String? {
        get {
            string(forKey: "token")
        }
        set {
            set(newValue, forKey: "token")
            synchronize()
        }
    }
}
