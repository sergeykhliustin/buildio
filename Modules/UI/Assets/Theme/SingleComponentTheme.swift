//
//  SingleComponentTheme.swift
//  Modules
//
//  Created by Sergii Khliustin on 07.11.2024.
//

import SwiftUI

struct SingleComponentTheme: ThemeType, Codable {
    let name: String
    let scheme: String
    var background: PlatformColor
    var textColor: PlatformColor
    var textColorLight: PlatformColor
    var accentColor: PlatformColor
    var accentColorLight: PlatformColor
    var linkColor: PlatformColor
    var submitButtonColor1: PlatformColor
    var submitButtonColor2: PlatformColor
    var disabledColor: PlatformColor
    var borderColor: PlatformColor
    var separatorColor: PlatformColor
    var logControlColor: PlatformColor
    var logControlHighlightedColor: PlatformColor
    var logsBackgroundColor: PlatformColor
    var shadowColor: PlatformColor
    var navigationColor: PlatformColor
    var fadeColor: PlatformColor
    var controlsColor: PlatformColor
    var abortButtonColor1: PlatformColor
    var abortButtonColor2: PlatformColor
    var errorBackground: PlatformColor
    var errorText: PlatformColor

    enum CodingKeys: String, CodingKey {
        case name
        case scheme
        case background
        case textColor
        case textColorLight
        case accentColor
        case accentColorLight
        case linkColor
        case submitButtonColor1
        case submitButtonColor2
        case disabledColor
        case borderColor
        case separatorColor
        case logControlColor
        case logControlHighlightedColor
        case logsBackgroundColor
        case shadowColor
        case navigationColor
        case fadeColor
        case controlsColor
        case abortButtonColor1
        case abortButtonColor2
        case errorBackground
        case errorText
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        scheme = try container.decode(String.self, forKey: .scheme)
        let background = try container.decode(String.self, forKey: .background)
        self.background = try PlatformColor(hex: background)
        let textColor = try container.decode(String.self, forKey: .textColor)
        self.textColor = try PlatformColor(hex: textColor)
        let textColorLight = try container.decode(String.self, forKey: .textColorLight)
        self.textColorLight = try PlatformColor(hex: textColorLight)
        let accentColor = try container.decode(String.self, forKey: .accentColor)
        self.accentColor = try PlatformColor(hex: accentColor)
        let accentColorLight = try container.decode(String.self, forKey: .accentColorLight)
        self.accentColorLight = try PlatformColor(hex: accentColorLight)
        let linkColor = try container.decode(String.self, forKey: .linkColor)
        self.linkColor = try PlatformColor(hex: linkColor)
        let submitButtonColor1 = try container.decode(String.self, forKey: .submitButtonColor1)
        self.submitButtonColor1 = try PlatformColor(hex: submitButtonColor1)
        let submitButtonColor2 = try container.decode(String.self, forKey: .submitButtonColor2)
        self.submitButtonColor2 = try PlatformColor(hex: submitButtonColor2)
        let disabledColor = try container.decode(String.self, forKey: .disabledColor)
        self.disabledColor = try PlatformColor(hex: disabledColor)
        let borderColor = try container.decode(String.self, forKey: .borderColor)
        self.borderColor = try PlatformColor(hex: borderColor)
        let separatorColor = try container.decode(String.self, forKey: .separatorColor)
        self.separatorColor = try PlatformColor(hex: separatorColor)
        let logControlColor = try container.decode(String.self, forKey: .logControlColor)
        self.logControlColor = try PlatformColor(hex: logControlColor)
        let logControlHighlightedColor = try container.decode(String.self, forKey: .logControlHighlightedColor)
        self.logControlHighlightedColor = try PlatformColor(hex: logControlHighlightedColor)
        let logsBackgroundColor = try container.decode(String.self, forKey: .logsBackgroundColor)
        self.logsBackgroundColor = try PlatformColor(hex: logsBackgroundColor)
        let shadowColor = try container.decode(String.self, forKey: .shadowColor)
        self.shadowColor = try PlatformColor(hex: shadowColor)
        let navigationColor = try container.decode(String.self, forKey: .navigationColor)
        self.navigationColor = try PlatformColor(hex: navigationColor)
        let fadeColor = try container.decode(String.self, forKey: .fadeColor)
        self.fadeColor = try PlatformColor(hex: fadeColor)
        let controlsColor = try container.decode(String.self, forKey: .controlsColor)
        self.controlsColor = try PlatformColor(hex: controlsColor)
        let abortButtonColor1 = try container.decode(String.self, forKey: .abortButtonColor1)
        self.abortButtonColor1 = try PlatformColor(hex: abortButtonColor1)
        let abortButtonColor2 = try container.decode(String.self, forKey: .abortButtonColor2)
        self.abortButtonColor2 = try PlatformColor(hex: abortButtonColor2)
        let errorBackground = try container.decode(String.self, forKey: .errorBackground)
        self.errorBackground = try PlatformColor(hex: errorBackground)
        let errorText = try container.decode(String.self, forKey: .errorText)
        self.errorText = try PlatformColor(hex: errorText)
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(scheme, forKey: .scheme)
        try container.encode(background.hex, forKey: .background)
        try container.encode(textColor.hex, forKey: .textColor)
        try container.encode(textColorLight.hex, forKey: .textColorLight)
        try container.encode(accentColor.hex, forKey: .accentColor)
        try container.encode(accentColorLight.hex, forKey: .accentColorLight)
        try container.encode(linkColor.hex, forKey: .linkColor)
        try container.encode(submitButtonColor1.hex, forKey: .submitButtonColor1)
        try container.encode(submitButtonColor2.hex, forKey: .submitButtonColor2)
        try container.encode(disabledColor.hex, forKey: .disabledColor)
        try container.encode(borderColor.hex, forKey: .borderColor)
        try container.encode(separatorColor.hex, forKey: .separatorColor)
        try container.encode(logControlColor.hex, forKey: .logControlColor)
        try container.encode(logControlHighlightedColor.hex, forKey: .logControlHighlightedColor)
        try container.encode(logsBackgroundColor.hex, forKey: .logsBackgroundColor)
        try container.encode(shadowColor.hex, forKey: .shadowColor)
        try container.encode(navigationColor.hex, forKey: .navigationColor)
        try container.encode(fadeColor.hex, forKey: .fadeColor)
        try container.encode(controlsColor.hex, forKey: .controlsColor)
        try container.encode(abortButtonColor1.hex, forKey: .abortButtonColor1)
        try container.encode(abortButtonColor2.hex, forKey: .abortButtonColor2)
        try container.encode(errorBackground.hex, forKey: .errorBackground)
        try container.encode(errorText.hex, forKey: .errorText)
    }

    // swiftlint:disable force_try
    static var defaultLight: SingleComponentTheme {
        let data = try! JSONSerialization.data(withJSONObject: defaultLightTheme, options: .prettyPrinted)
        let decoder = JSONDecoder()
        return try! decoder.decode(SingleComponentTheme.self, from: data)
    }

    static var defaultDark: SingleComponentTheme {
        let data = try! JSONSerialization.data(withJSONObject: defaultDarkTheme, options: .prettyPrinted)
        let decoder = JSONDecoder()
        return try! decoder.decode(SingleComponentTheme.self, from: data)
    }
    // swiftlint:enable force_try

    private static let defaultLightTheme = [
        "name": "Default",
        "scheme": "light",

        "accentColor": "#440C59",
        "accentColorLight": "#492D5B5F",
        "background": "#FEFEFE",
        "borderColor": "#ADADADA7",
        "controlsColor": "#454545",
        "disabledColor": "#ADADAD",
        "fadeColor": "#84848425",
        "linkColor": "#6C0EB2",
        "logControlColor": "#6E6F6F",
        "logsBackgroundColor": "#000000",
        "logControlHighlightedColor": "#683d87",
        "navigationColor": "#2D063C",
        "separatorColor": "#DEDEDE",
        "shadowColor": "#EAEAEA",
        "submitButtonColor1": "#E292FE",
        "submitButtonColor2": "#440C59",
        "textColor": "#000000",
        "textColorLight": "#341D4799",
        "abortButtonColor1": "#FF8C82",
        "abortButtonColor2": "#831100",
        "errorBackground": "#F65454",
        "errorText": "#FFFFFF"
    ]

    private static let defaultDarkTheme = [
        "name": "Sea Green",
        "scheme": "dark",

        "abortButtonColor1": "#FE8646",
        "abortButtonColor2": "#3C3300",
        "accentColor": "#FEFFFF",
        "accentColorLight": "#99999999",
        "background": "#003037",
        "borderColor": "#999999",
        "controlsColor": "#06ADCE",
        "disabledColor": "#999999",
        "fadeColor": "#FFFFFF26",
        "linkColor": "#06ADCE",
        "logControlColor": "#5B5B5B",
        "logsBackgroundColor": "#201B22",
        "logControlHighlightedColor": "#683d87",
        "navigationColor": "#EAEAEA",
        "separatorColor": "#848484",
        "shadowColor": "#FFFFFF18",
        "submitButtonColor1": "#00C7FC",
        "submitButtonColor2": "#253E0F",
        "textColor": "#FEFEFE",
        "textColorLight": "#FEFEFE99",
        "errorBackground": "#F65454",
        "errorText": "#FFFFFF"
    ]

    private static let annDarkTheme = [
        "name": "Ann Dark",
        "scheme": "dark",

        "accentColor": "#FEFFFF",
        "accentColorLight": "#99999999",
        "background": "#000000",
        "borderColor": "#999999",
        "controlsColor": "#CDCDCD",
        "disabledColor": "#999999",
        "fadeColor": "#FFFFFF26",
        "linkColor": "#ADADAD",
        "logControlColor": "#FFFFFF",
        "logControlHighlightedColor": "#683d87",
        "logsBackgroundColor": "#201B22",
        "navigationColor": "#EAEAEA",
        "separatorColor": "#848484",
        "shadowColor": "#FEFFFF00",
        "submitButtonColor1": "#982ABC",
        "submitButtonColor2": "#450673",
        "textColor": "#FEFEFE",
        "textColorLight": "#FEFEFE99",
        "abortButtonColor1": "#FF4014",
        "abortButtonColor2": "#710E00",
        "errorBackground": "#F65454",
        "errorText": "#FFFFFF"
    ]

    private static let khndzTheme = [
        "name": "Khndz Dark",
        "scheme": "dark",

        "abortButtonColor1": "#FE8646",
        "abortButtonColor2": "#B51A00",
        "accentColor": "#FEFFFF",
        "accentColorLight": "#99999999",
        "background": "#000000",
        "borderColor": "#999999",
        "controlsColor": "#FEFFFF",
        "disabledColor": "#999999",
        "fadeColor": "#FFFFFF26",
        "linkColor": "#06ADCE",
        "logControlColor": "#FFFFFF",
        "logControlHighlightedColor": "#683d87",
        "logsBackgroundColor": "#201B22",
        "navigationColor": "#EAEAEA",
        "separatorColor": "#848484",
        "shadowColor": "#FFFFFF18",
        "submitButtonColor1": "#00C7FC",
        "submitButtonColor2": "#003549",
        "textColor": "#FEFEFE",
        "textColorLight": "#FEFEFE99",
        "errorBackground": "#F65454",
        "errorText": "#FFFFFF"
    ]
}
