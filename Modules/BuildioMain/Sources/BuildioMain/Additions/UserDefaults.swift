//
//  UserDefaults.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 18.11.2021.
//

import Foundation

extension UserDefaults {
    private struct Keys {
        static let lightTheme = "lightTheme"
        static let darkTheme = "darkTheme"
        static let backgroundAnalytics = "background_analytics"
        static let lastActivityDates = "last_activity_dates"
    }
    
    var lightTheme: Theme? {
        get {
            if let data = data(forKey: Keys.lightTheme) {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
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
            encoder.keyEncodingStrategy = .convertToSnakeCase
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
                decoder.keyDecodingStrategy = .convertFromSnakeCase
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
            encoder.keyEncodingStrategy = .convertToSnakeCase
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
