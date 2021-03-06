//
//  UserDefaults.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 18.11.2021.
//

import Foundation
import SwiftUI

public struct AccountSettings: Codable {
    public var mutedApps: [String] = []
}

public extension UserDefaults {
    struct Keys {
        public static let theme = "theme"
        public static let lightTheme = "lightTheme"
        public static let darkTheme = "darkTheme"
        public static let backgroundAnalytics = "background_analytics"
        public static let lastActivityDates = "last_activity_dates"
        public static let debugMode = "debugMode"
        public static let lightThemeName = "lightThemeName"
        public static let darkThemeName = "darkThemeName"
        public static let pollingInterval = "pollingInterval"
        public static let lastAccount = "lastAccount"
        public static let appOpenCount = "appOpenCount"
        public static let reviewRequestCount = "reviewRequestCount"
        public static let accountSettings = "accountSettings"
        public static let matchingPipelineMuted = "matchingPipelineMuted"
    }
    
    enum ColorSchemeSettings: String, CaseIterable, Identifiable {
        public var id: String {
            rawValue
        }
        case system = "System"
        case light = "Light"
        case dark = "Dark"
        
        public var colorScheme: ColorScheme? {
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
    
    var colorSchemeSettings: ColorSchemeSettings {
        get {
            if let string = string(forKey: Keys.theme), let settings = ColorSchemeSettings(rawValue: string) {
                return settings
            }
            return .system
        }
        set {
            set(newValue, forKey: Keys.theme)
        }
    }
    
    func themeName(for scheme: ColorScheme) -> String? {
        if scheme == .dark {
            return darkThemeName
        } else {
            return lightThemeName
        }
    }
    
    func setThemeName(_ name: String?, for scheme: ColorScheme) {
        if scheme == .dark {
            self.darkThemeName = name
        } else {
            self.lightThemeName = name
        }
    }
    
    var lightThemeName: String? {
        get {
            string(forKey: Keys.lightThemeName)
        }
        set {
            set(newValue, forKey: Keys.lightThemeName)
            synchronize()
        }
    }
    
    var darkThemeName: String? {
        get {
            string(forKey: Keys.darkThemeName)
        }
        set {
            set(newValue, forKey: Keys.darkThemeName)
            synchronize()
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
    
    var pollingInterval: TimeInterval {
        get {
            value(forKey: Keys.pollingInterval) as? Double ?? 30.0
        }
        set {
            set(newValue, forKey: Keys.pollingInterval)
            synchronize()
        }
    }
    
    var lastAccount: String? {
        get {
            string(forKey: Keys.lastAccount)
        }
        set {
            set(newValue, forKey: Keys.lastAccount)
            synchronize()
        }
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
    
    var reviewRequestCount: Int {
        get {
            integer(forKey: Keys.reviewRequestCount)
        }
        set {
            set(newValue, forKey: Keys.reviewRequestCount)
            synchronize()
        }
    }
    
    var appOpenCount: Int {
        get {
            integer(forKey: Keys.appOpenCount)
        }
        set {
            set(newValue, forKey: Keys.appOpenCount)
            synchronize()
        }
    }

    func accountSettings(for account: String) -> AccountSettings {
        return self.accountsSettings[account] ?? AccountSettings()
    }

    func setAccountSettings(_ settings: AccountSettings, for account: String) {
        accountsSettings[account] = settings
    }

    private(set) var accountsSettings: [String: AccountSettings] {
        get {
            let decoder = JSONDecoder()
            guard let data = data(forKey: Keys.accountSettings),
                  let object = try? decoder.decode([String: AccountSettings].self, from: data) else {
                return [:]
            }
            return object
        }
        set {
            let encoder = JSONEncoder()
            do {
                let data = try encoder.encode(newValue)
                set(data, forKey: Keys.accountSettings)
                synchronize()
            } catch {
                logger.error(error)
            }
        }
    }

    var isMatchingPipelineMuted: Bool {
        get {
            bool(forKey: Keys.matchingPipelineMuted)
        }
        set {
            set(newValue, forKey: Keys.matchingPipelineMuted)
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
