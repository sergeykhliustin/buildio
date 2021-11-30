//
//  RootScreenItemType.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 25.11.2021.
//
import SwiftUI

enum RootScreenItemType {
    case builds
    case apps
    case accounts
    case profile
    case activities
    case debug
    
    var name: String {
        switch self {
        case .builds:
            return "Builds"
        case .apps:
            return "Apps"
        case .accounts:
            return "Accounts"
        case .profile:
            return "Profile"
        case .activities:
            return "Activities"
        case .debug:
            return "Debug"
        }
    }
    
    var icon: String {
        switch self {
        case .builds:
            return "hammer"
        case .apps:
            return "tray.2"
        case .accounts:
            return "key"
        case .profile:
            return "person.crop.circle"
        case .activities:
            return "bell"
        case .debug:
            return "bolt.heart"
        }
    }
    
    var navigation: Bool {
        return self != .debug
    }
    
    #if DEBUG
    static let `default`: [RootScreenItemType] = [
        .builds,
        .apps,
        .accounts,
        .activities,
        .debug
    ]
    #else
    static let `default`: [RootScreenItemType] = [
        .builds,
        .apps,
        .accounts,
        .activities
    ]
    #endif
}
