//
//  BuildioApp.swift
//  Shared
//
//  Created by severehed on 01.10.2021.
//

import SwiftUI

@main
struct BuildioApp: App {
    
    var body: some Scene {
        testMe()
        return WindowGroup {
            ContentView()
        }
    }
    
    func testMe() {
        UserAPI.userProfile { data, error in
            print(data)
        }
    }
}
