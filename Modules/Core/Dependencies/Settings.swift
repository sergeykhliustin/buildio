//
//  Settings.swift
//  Modules
//
//  Created by Sergii Khliustin on 08.11.2024.
//

import SwiftUI

package struct Settings: Codable, Equatable {
    package static let key: String = "Settings"
    package var muteAllNoPipeline: Bool = true
    package var preferredColorScheme: ColorScheme?
    package var pollingInterval: Double = 30
    // Token Email: [AppName]
    package var mutedApps: [String: [String]] = [:]

    package init() {}
}

package extension UserDefaults {
    var settings: Settings {
        get {
            if let data = data(forKey: Settings.key),
               let settings = try? JSONDecoder().decode(Settings.self, from: data) {
                return settings
            }
            return Settings()
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else { return }
            set(data, forKey: Settings.key)
        }
    }
}

extension ColorScheme: Codable {
    package var string: String {
        switch self {
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        @unknown default:
            return "Light"
        }
    }

    package init(string: String) throws {
        switch string {
        case "Light":
            self = .light
        case "Dark":
            self = .dark
        default:
            self = .light
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        self = try ColorScheme(string: value)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(string)
    }
}
