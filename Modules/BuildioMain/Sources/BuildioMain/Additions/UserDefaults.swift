//
//  UserDefaults.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 18.11.2021.
//

import Foundation
import SwiftUI

enum ThemeSettings: String, CaseIterable, Identifiable {
    var id: String {
        rawValue
    }
    case system = "System"
    case light = "Light"
    case dark = "Dark"
    
    var colorScheme: ColorScheme? {
        switch self {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

extension UserDefaults {
    struct Keys {
        static let theme = "theme"
        static let lightTheme = "lightTheme"
        static let darkTheme = "darkTheme"
        static let backgroundAnalytics = "background_analytics"
        static let lastActivityDates = "last_activity_dates"
        static let debugMode = "debugMode"
    }
    
    var themeSettings: ThemeSettings {
        get {
            if let string = string(forKey: Keys.theme), let settings = ThemeSettings(rawValue: string) {
                return settings
            }
            return .system
        }
        set {
            set(newValue, forKey: Keys.theme)
        }
    }
    
    var lightTheme: Theme? {
        get {
            if let data = data(forKey: Keys.lightTheme) {
                let decoder = JSONDecoder()
                do {
                    return try decoder.decode(Theme.self, from: data)
                } catch {
                    logger.error(error)
                }
            }
            return nil
        }
        set {
            let encoder = JSONEncoder()
            do {
                let data = try encoder.encode(newValue)
                set(data, forKey: Keys.lightTheme)
                synchronize()
            } catch {
                logger.error(error)
            }
        }
    }
    
    var darkTheme: Theme? {
        get {
            if let data = data(forKey: Keys.darkTheme) {
                let decoder = JSONDecoder()
                do {
                    return try decoder.decode(Theme.self, from: data)
                } catch {
                    logger.error(error)
                }
            }
            return nil
        }
        set {
            let encoder = JSONEncoder()
            do {
                let data = try encoder.encode(newValue)
                set(data, forKey: Keys.darkTheme)
                synchronize()
            } catch {
                logger.error(error)
            }
        }
    }
    
    var backgroundAnalytics: [String: Int] {
        get {
            return dictionary(forKey: Keys.backgroundAnalytics) as? [String: Int] ?? [:]
        }
        set {
            set(newValue, forKey: Keys.backgroundAnalytics)
            synchronize()
        }
    }
    
    func lastActivityDate(email: String) -> TimeInterval {
        if let double = dictionary(forKey: Keys.lastActivityDates)?[email] as? Double {
            return double
        }
        return 0
    }
    
    func setLastActivityDate(_ date: TimeInterval, email: String) {
        lastActivityDates[email] = date
    }
    
    private var lastActivityDates: [String: Double] {
        get {
            dictionary(forKey: Keys.lastActivityDates) as? [String: Double] ?? [:]
        }
        set {
            set(newValue, forKey: Keys.lastActivityDates)
            synchronize()
        }
    }
    
    func reset() {
        lastActivityDates = [:]
        removeObject(forKey: Keys.lightTheme)
        removeObject(forKey: Keys.darkTheme)
        synchronize()
    }
    
    func resetTheme() {
        removeObject(forKey: Keys.lightTheme)
        removeObject(forKey: Keys.darkTheme)
        synchronize()
    }
}
