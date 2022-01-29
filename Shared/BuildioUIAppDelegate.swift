//
//  AppDelegate.swift
//  Buildio
//
//  Created by Sergey Khliustin on 03.11.2021.
//

import Foundation
import UIKit
import BuildioMain

public final class BuildioUIAppDelegate: NSObject, UIApplicationDelegate {
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        BackgroundProcessing.shared.start()
        _ = setStatusMenuEnabled(true)
        return true
    }
    
    private func setStatusMenuEnabled(_ isEnabled: Bool) -> Bool {
        let bundleId = "com.sergeyk.BuildioStatusBar" as CFString
        return SMLoginItemSetEnabled(bundleId, isEnabled)
    }
}
