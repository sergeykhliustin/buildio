//
//  AppDelegate.swift
//  Buildio
//
//  Created by Sergey Khliustin on 03.11.2021.
//

import Foundation
import UIKit
import Combine
import BackgroundTasks
import BitriseAPIs

public final class BuildioUIAppDelegate: NSObject, UIApplicationDelegate {
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        BackgroundProcessing.shared.start()
        return true
    }
}
