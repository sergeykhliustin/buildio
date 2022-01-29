//
//  BuildioStatusBarApp.swift
//  BuildioStatusBar
//
//  Created by Sergey Khliustin on 29.01.2022.
//

import SwiftUI
import AppKit

class BuildioStatusBarApp: NSApplication {
    let appDelegate = BuildioStatusBarNSAppDelegate()
    
    override init() {
        super.init()
        self.delegate = appDelegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//@main
//struct BuildioStatusBarApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}
