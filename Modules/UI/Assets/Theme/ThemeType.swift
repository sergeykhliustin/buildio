//
//  ThemeType.swift
//  Modules
//
//  Created by Sergii Khliustin on 07.11.2024.
//

import SwiftUI

package protocol ThemeType: Sendable {
    typealias Shadow = (color: PlatformColor, radius: CGFloat, x: CGFloat, y: CGFloat)

    var background: PlatformColor { get }
    var textColor: PlatformColor { get }
    var textColorLight: PlatformColor { get }
    var accentColor: PlatformColor { get }
    var accentColorLight: PlatformColor { get }
    var linkColor: PlatformColor { get }
    var submitButtonColor1: PlatformColor { get }
    var submitButtonColor2: PlatformColor { get }
    var disabledColor: PlatformColor { get }
    var borderColor: PlatformColor { get }
    var separatorColor: PlatformColor { get }
    var logControlColor: PlatformColor { get }
    var logControlHighlightedColor: PlatformColor { get }
    var logsBackgroundColor: PlatformColor { get }
    var shadowColor: PlatformColor { get }
    var navigationColor: PlatformColor { get }
    var fadeColor: PlatformColor { get }
    var controlsColor: PlatformColor { get }
    var abortButtonColor1: PlatformColor { get }
    var abortButtonColor2: PlatformColor { get }
    var errorBackground: PlatformColor { get }
    var errorText: PlatformColor { get }
}

package extension ThemeType {
    var listShadow: Shadow {
        return (shadowColor, 10, 0, 0)
    }

    var tabBarBackgroundShadow: Shadow {
        return (shadowColor, 3, 0, -5)
    }
}
