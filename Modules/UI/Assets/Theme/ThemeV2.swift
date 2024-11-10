//
//  ThemeV2.swift
//  Modules
//
//  Created by Sergii Khliustin on 07.11.2024.
//

package struct ThemeV2: ThemeType {
    package var background: PlatformColor
    package var textColor: PlatformColor
    package var textColorLight: PlatformColor
    package var accentColor: PlatformColor
    package var accentColorLight: PlatformColor
    package var linkColor: PlatformColor
    package var submitButtonColor1: PlatformColor
    package var submitButtonColor2: PlatformColor
    package var disabledColor: PlatformColor
    package var borderColor: PlatformColor
    package var separatorColor: PlatformColor
    package var logControlColor: PlatformColor
    package var logControlHighlightedColor: PlatformColor
    package var logsBackgroundColor: PlatformColor
    package var shadowColor: PlatformColor
    package var navigationColor: PlatformColor
    package var fadeColor: PlatformColor
    package var controlsColor: PlatformColor
    package var abortButtonColor1: PlatformColor
    package var abortButtonColor2: PlatformColor
    package var errorBackground: PlatformColor
    package var errorText: PlatformColor

    package static var `default`: ThemeV2 {
        return .init(light: .defaultLight, dark: .defaultDark)
    }

    init(light: SingleComponentTheme, dark: SingleComponentTheme) {
        self.background = PlatformColor(light: light.background, dark: dark.background)
        self.textColor = PlatformColor(light: light.textColor, dark: dark.textColor)
        self.textColorLight = PlatformColor(light: light.textColorLight, dark: dark.textColorLight)
        self.accentColor = PlatformColor(light: light.accentColor, dark: dark.accentColor)
        self.accentColorLight = PlatformColor(light: light.accentColorLight, dark: dark.accentColorLight)
        self.linkColor = PlatformColor(light: light.linkColor, dark: dark.linkColor)
        self.submitButtonColor1 = PlatformColor(light: light.submitButtonColor1, dark: dark.submitButtonColor1)
        self.submitButtonColor2 = PlatformColor(light: light.submitButtonColor2, dark: dark.submitButtonColor2)
        self.disabledColor = PlatformColor(light: light.disabledColor, dark: dark.disabledColor)
        self.borderColor = PlatformColor(light: light.borderColor, dark: dark.borderColor)
        self.separatorColor = PlatformColor(light: light.separatorColor, dark: dark.separatorColor)
        self.logControlColor = PlatformColor(light: light.logControlColor, dark: dark.logControlColor)
        self.logControlHighlightedColor = PlatformColor(light: light.logControlHighlightedColor, dark: dark.logControlHighlightedColor)
        self.logsBackgroundColor = PlatformColor(light: light.logsBackgroundColor, dark: dark.logsBackgroundColor)
        self.shadowColor = PlatformColor(light: light.shadowColor, dark: dark.shadowColor)
        self.navigationColor = PlatformColor(light: light.navigationColor, dark: dark.navigationColor)
        self.fadeColor = PlatformColor(light: light.fadeColor, dark: dark.fadeColor)
        self.controlsColor = PlatformColor(light: light.controlsColor, dark: dark.controlsColor)
        self.abortButtonColor1 = PlatformColor(light: light.abortButtonColor1, dark: dark.abortButtonColor1)
        self.abortButtonColor2 = PlatformColor(light: light.abortButtonColor2, dark: dark.abortButtonColor2)
        self.errorBackground = PlatformColor(light: light.errorBackground, dark: dark.errorBackground)
        self.errorText = PlatformColor(light: light.errorText, dark: dark.errorText)
    }
}
