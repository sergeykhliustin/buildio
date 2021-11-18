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

final class AppDelegate: NSObject, UIApplicationDelegate {
    static let refreshTaskId = "refreshTaskId"
    private var fetcher: AnyCancellable?
    private var notificationCenterPubliser: AnyCancellable?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        NotificationManager.checkPermissionGranted { granted in
            if !granted {
                NotificationManager.requestAuthorization { _ in
                    
                }
            }
        }
        BGTaskScheduler.shared.register(forTaskWithIdentifier: AppDelegate.refreshTaskId, using: nil) { [weak self] task in
            logger.debug("[BGTASK] Perform bg fetch \(AppDelegate.refreshTaskId)")
            guard let self = self else {
                logger.debug("[BGTASK] AppDelegate is nil")
                return
            }
            self.fetcher?.cancel()
            self.fetcher = ActivityAPI()
                .activityList(next: UserDefaults.standard.lastActivitySlug, limit: 1)
                .sink { [weak self] completion in
                    task.setTaskCompleted(success: true)
                    self?.scheduleAppRefresh()
                } receiveValue: { value in
                    UserDefaults.standard.lastActivitySlug = value.data.first?.slug
                    if let activity = value.data.first,
                       activity.eventStype == "build",
                       let title = activity.title,
                        let subtitle = activity.description {
                        DispatchQueue.main.async {
                            NotificationManager.runNotification(with: title, subtitle: subtitle, id: activity.slug) { error in
                                if let error = error {
                                    logger.error("[BGTASK] \(error)")
                                }
                            }
                        }
                        
                    }
                }
            task.expirationHandler = { [weak self] in
                logger.debug("[BGTASK] expired")
                self?.fetcher?.cancel()
            }
        }
        notificationCenterPubliser =
        NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification).sink { [weak self] _ in
            
        } receiveValue: { [weak self] _ in
            self?.scheduleAppRefresh()
        }

        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        scheduleAppRefresh()
    }
    
    func scheduleAppRefresh() {
        logger.debug("[BGTASK] scheduling app refresh")
        let request = BGAppRefreshTaskRequest(identifier: AppDelegate.refreshTaskId)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 10)
        
        do {
            try BGTaskScheduler.shared.submit(request)
            logger.debug("[BGTASK] submitted")
        } catch {
            let error = error
            logger.debug("Could not schedule app refresh task \(error.localizedDescription)")
        }
    }
}

public class NotificationManager {
    
    public static func checkPermissionGranted(completion: @escaping  (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else {
                
                if settings.authorizationStatus == .notDetermined {
                    requestAuthorization(completion: completion)
                } else {
                    completion(false)
                }
                return
            }
            
            if settings.alertSetting == .enabled {
                completion(true)
                // Schedule an alert-only notification.
            } else {
                completion(false)
                // Schedule a notification with a badge and sound.
            }
        }
    }
    
    public static func requestAuthorization(completion: @escaping  (Bool) -> Void) {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _  in
                completion(granted)
            }
    }
    
    public static func runNotification(with title: String, subtitle: String, id: String, threadIdentifier: String = "", completion: @escaping  (Error?) -> Void) {
        
        logger.debug("run Notification")
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = subtitle
        content.threadIdentifier = threadIdentifier
        logger.debug("content configured")
        
        let trigger: UNNotificationTrigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 2,
            repeats: false)
        logger.debug("trigger configured")
        
        let request = UNNotificationRequest(
            identifier: id,
            content: content,
            trigger: trigger)
        logger.debug("request configured")
        
        UNUserNotificationCenter.current().add(request) { error in
            logger.debug("Local notification error \(String(describing: error?.localizedDescription))")
            completion(error)
        }
    }
}
