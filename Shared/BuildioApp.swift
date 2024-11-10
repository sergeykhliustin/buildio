//
//  BuildioApp.swift
//  Shared
//
//  Created by Sergey Khliustin on 01.10.2021.
//

import SwiftUI
import Coordinator

@main
struct BuildioApp: App {
    #if os(iOS)
    @UIApplicationDelegateAdaptor(BuildioAppDelegate.self) var appDelegate
    #endif

    var body: some Scene {
        WindowGroup("Buildio") {
            CoordinatorPage(viewModel: CoordinatorPageModel())
        }
    }
}
