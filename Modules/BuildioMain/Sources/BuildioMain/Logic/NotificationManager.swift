//
//  File.swift
//  
//
//  Created by Sergey Khliustin on 29.11.2021.
//

import Foundation
import UserNotifications

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
        
        let request = UNNotificationRequest(
            identifier: id,
            content: content,
            trigger: nil)
        logger.debug("request configured")
        
        UNUserNotificationCenter.current().add(request) { error in
            logger.debug("Local notification error \(String(describing: error?.localizedDescription))")
            completion(error)
        }
    }
}
