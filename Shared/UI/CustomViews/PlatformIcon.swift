//
//  PlatformIcon.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 05.11.2021.
//

import SwiftUI

struct PlatformIcon: View {
    private enum Platform: String {
        case ios
    }

    private static let icons: [Platform: String] = [
        .ios: "applelogo"
    ]

    private static let defaultIcon = "target"
    
    private let iconName: String
    
    init(_ platformString: String?) {
        if let platformString = platformString,
           let platform = Platform(rawValue: platformString),
           let iconName = Self.icons[platform] {
            self.iconName = iconName
        } else {
            self.iconName = Self.defaultIcon
        }
    }
    var body: some View {
        Image(systemName: iconName)
    }
}

struct PlatformIcon_Previews: PreviewProvider {
    static var previews: some View {
        PlatformIcon("ios")
    }
}
