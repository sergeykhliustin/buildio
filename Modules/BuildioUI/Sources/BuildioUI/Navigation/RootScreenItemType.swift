//
//  RootScreenItemType.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 25.11.2021.
//
import SwiftUI

enum RootScreenItemType: CaseIterable {
    case auth
    case builds
    case apps
    case accounts
    case activities
    case settings
    
    var id: String {
        return name
    }
    
    var name: String {
        switch self {
        case .auth:
            return "Auth"
        case .builds:
            return "Builds"
        case .apps:
            return "Apps"
        case .accounts:
            return "Accounts"
        case .activities:
            return "Activities"
        case .settings:
            return "Settings"
        }
    }
    
    var icon: Images {
        switch self {
        case .auth:
            return .empty
        case .builds:
            return .hammer
        case .apps:
            return .tray_2
        case .accounts:
            return .key
        case .activities:
            return .bell
        case .settings:
            return .gearshape
        }
    }

    var iconFill: Images {
        switch self {
        case .auth:
            return .empty
        case .builds:
            return .hammer_fill
        case .apps:
            return .tray_2_fill
        case .accounts:
            return .key_fill
        case .activities:
            return .bell_fill
        case .settings:
            return .gearshape_fill
        }
    }
    
    var splitNavigation: Bool {
        return ![Self.accounts, Self.activities, Self.settings].contains(self)
    }
    
    static let `default`: [RootScreenItemType] = [
        .builds,
        .apps,
        .accounts,
        .settings
    ]
    
    static let preview: [RootScreenItemType] = [
        .builds,
        .apps
    ]
}
