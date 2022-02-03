//
//  AppDelegate.swift
//  Buildio
//
//  Created by Sergey Khliustin on 03.11.2021.
//

import Foundation
import UIKit
import Combine
import UserNotifications
import BuildioLogic

public final class BuildioUIAppDelegate: NSObject, UIApplicationDelegate {
    var statusBarPlugin: MacStatusBarPluginProtocol?
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        #if targetEnvironment(macCatalyst)
        BackgroundProcessingMac.shared.start()
        #else
        BackgroundProcessing.shared.start()
        #endif
        
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()
        
        return true
    }
    
    private func loadPlugin() {
        let bundleFileName = "MacStatusBarPlugin.bundle"
        guard let bundleURL = Bundle.main.builtInPlugInsURL?
                .appendingPathComponent(bundleFileName) else { return }
        
        guard let bundle = Bundle(url: bundleURL) else { return }
        
        let className = "MacStatusBarPlugin.MacStatusBarPlugin"
        guard let pluginClass = bundle.classNamed(className) as? MacStatusBarPluginProtocol.Type else { return }

        let plugin = pluginClass.init { action in
            switch action {
            case .newWindow:
                UIApplication.shared.requestSceneSessionActivation(nil, userActivity: nil, options: nil) { error in
                    
                }
            }
        }
        plugin.setup()
        self.statusBarPlugin = plugin
    }
}
