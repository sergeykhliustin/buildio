//
//  UserDefaults.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 18.11.2021.
//

import Foundation

extension UserDefaults {
    var lightTheme: Theme? {
        get {
            if let data = data(forKey: "lightTheme") {
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
                set(data, forKey: "lightTheme")
                synchronize()
            } catch {
                logger.error(error)
            }
        }
    }
    
    var darkTheme: Theme? {
        get {
            if let data = data(forKey: "darkTheme") {
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
                set(data, forKey: "darkTheme")
                synchronize()
            } catch {
                logger.error(error)
            }
        }
    }
    
    func lastActivityDate(email: String) -> TimeInterval {
        if let double = dictionary(forKey: "last_activity_dates")?[email] as? Double {
            return double
        }
        return 0
    }
    
    func setLastActivityDate(_ date: TimeInterval, email: String) {
        lastActivityDates[email] = date
    }
    
    private var lastActivityDates: [String: Double] {
        get {
            dictionary(forKey: "last_activity_dates") as? [String: Double] ?? [:]
        }
        set {
            set(newValue, forKey: "last_activity_dates")
            synchronize()
        }
    }
    
    func reset() {
        lastActivityDates = [:]
    }
}
