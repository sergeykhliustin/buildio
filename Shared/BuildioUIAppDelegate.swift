//
//  AppDelegate.swift
//  Buildio
//
//  Created by Sergey Khliustin on 03.11.2021.
//

import Foundation
import Combine
import UserNotifications

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif
import Coordinator

#if os(iOS)
final class BuildioAppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        BackgroundProcessing.shared.start()
        
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()

        URLCache.shared.memoryCapacity = 30 * 1024 * 1024   // 30MB
        URLCache.shared.diskCapacity = 40 * 1024 * 1024    // 40MB

        return true
    }
}
#endif
