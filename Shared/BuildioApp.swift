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
        WindowGroup {
            MainCoordinatorView()
                .frame(minWidth: 400, idealWidth: 800, minHeight: 400, idealHeight: 800)
                .background(Color.white)
        }
    }
}
