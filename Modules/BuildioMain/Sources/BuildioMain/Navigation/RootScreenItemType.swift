//
//  RootScreenItemType.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 25.11.2021.
//
import SwiftUI

enum RootScreenItemType: CaseIterable {
    case builds
    case apps
    case accounts
    case activities
    case debug
    case theme
    
    var id: String {
        return name
    }
    
    var name: String {
        switch self {
        case .builds:
            return "Builds"
        case .apps:
            return "Apps"
        case .accounts:
            return "Accounts"
        case .activities:
            return "Activities"
        case .debug:
            return "Debug"
        case .theme:
            return "Theme"
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
        case .activities:
            return "bell"
        case .debug:
            return "bolt.heart"
        case .theme:
            return "bolt.heart"
        }
    }
    
    var splitNavigation: Bool {
        return ![Self.debug, Self.accounts, Self.theme].contains(self)
    }
    
    #if DEBUG
    static let `default`: [RootScreenItemType] = [
        .builds,
        .apps,
        .accounts,
        .activities,
        .debug,
        .theme
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
