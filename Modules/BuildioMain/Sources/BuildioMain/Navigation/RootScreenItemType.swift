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
    
    var icon: String {
        switch self {
        case .auth:
            return ""
        case .builds:
            return "hammer"
        case .apps:
            return "tray.2"
        case .accounts:
            return "key"
        case .activities:
            return "bell"
        case .settings:
            return "gearshape"
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
