//
//  BuildioApp.swift
//  Shared
//
//  Created by Sergey Khliustin on 01.10.2021.
//

import SwiftUI
import UIKit
import BuildioUI

@main
struct BuildioApp: App {
    @UIApplicationDelegateAdaptor(BuildioUIAppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup("Buildio") {
            EntryPoint()
        }
    }
}
