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
    static let appRefreshTaskId = "buildio.appRefreshTask"
    static let processingTasksIds = (0..<10).map({ "buildio.processingTask\($0)" })
    private var fetcher: AnyCancellable?
    private var longFetcher: AnyCancellable?
    private var notificationCenterPubliser: AnyCancellable?
    
    private lazy var launchHandler: (BGTask) -> Void = { [weak self] task in
        let identifier = task.identifier
        logger.debug("[BGTASK] Perform bg fetch \(identifier)")
        guard let self = self else {
            logger.debug("[BGTASK] AppDelegate is nil")
            return
        }
        self.fetcher?.cancel()
        self.fetcher = ActivityAPI()
            .activityList(next: nil, limit: 1)
            .sink { [weak self] completion in
                task.setTaskCompleted(success: true)
                self?.scheduleAppRefresh()
            } receiveValue: { value in
                if let activity = value.data.first,
                   activity.eventStype == "build",
                   let title = activity.title,
                   let subtitle = activity.description {
                    DispatchQueue.main.async {
                        UserDefaults.standard.lastActivitySlug = activity.slug
                        NotificationManager.runNotification(with: identifier, subtitle: [title, subtitle].joined(separator: " "), id: UUID().uuidString) { error in
                            if let error = error {
                                logger.error("[BGTASK \(identifier)] \(error)")
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        NotificationManager.runNotification(with: identifier, subtitle: "no updates", id: UUID().uuidString) { error in
                            if let error = error {
                                logger.error("[BGTASK \(identifier)] \(error)")
                            }
                        }
                    }
                }
            }
        task.expirationHandler = { [weak self] in
            logger.debug("[BGTASK \(identifier)] expired")
            self?.fetcher?.cancel()
        }
    }
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        BaseAPI.defaultApiToken = { TokenManager.shared.token?.token }
        ViewModelResolver.start()
        
        NotificationManager.checkPermissionGranted { granted in
            if !granted {
                NotificationManager.requestAuthorization { _ in
                    
                }
            }
        }
        
        ([Self.appRefreshTaskId] + Self.processingTasksIds).forEach { identifier in
            BGTaskScheduler.shared.register(forTaskWithIdentifier: identifier, using: nil, launchHandler: launchHandler)
        }
        
        notificationCenterPubliser =
        NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification).sink { _ in
            
        } receiveValue: { [weak self] _ in
            self?.scheduleAppRefresh()
        }

        return true
    }
    
    public func applicationDidEnterBackground(_ application: UIApplication) {
        scheduleAppRefresh()
    }
    
    func scheduleAppRefresh() {
        BGTaskScheduler.shared.getPendingTaskRequests { tasks in
            if !tasks.contains(where: { $0.identifier == Self.appRefreshTaskId }) {
                logger.debug("[\(Self.appRefreshTaskId)] scheduling app refresh")
                let request = BGAppRefreshTaskRequest(identifier: Self.appRefreshTaskId)
                request.earliestBeginDate = Date(timeIntervalSinceNow: 0)
                
                do {
                    try BGTaskScheduler.shared.submit(request)
                    logger.debug("[\(Self.appRefreshTaskId)] submitted")
                } catch {
                    let error = error
                    logger.debug("Could not schedule \(Self.appRefreshTaskId) \(error)")
                }
            }
            
            Self.processingTasksIds.forEach { identifier in
                if !tasks.contains(where: { $0.identifier == identifier }) {
                    logger.debug("[\(identifier)] scheduling app refresh")
                    let request = BGProcessingTaskRequest(identifier: identifier)
                    request.earliestBeginDate = Date(timeIntervalSinceNow: 0)
                    
                    do {
                        try BGTaskScheduler.shared.submit(request)
                        logger.debug("[\(identifier)] submitted")
                    } catch {
                        let error = error
                        logger.debug("Could not schedule \(identifier) \(error)")
                    }
                }
            }
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
