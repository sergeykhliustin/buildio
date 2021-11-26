//
//  Color.swift
//  Buildio
//
//  Created by Sergey Khliustin on 21.10.2021.
//

import SwiftUI
import Models

extension Color {
    static let b_TextBlack = Color(hex: 0x351d48)
    static let b_TextBlackLight = Color(hex: 0x351d48).opacity(0.6)
    static let b_BuildFailed = Color(hex: 0xff2158)
    static let b_BuildFailedLight = b_BuildFailed.opacity(0.16)
    static let b_BuildAborted = Color(hex: 0xffc500)
    static let b_BuildAbortedLight = b_BuildAborted.opacity(0.16)
    static let b_BuildSuccess = Color(hex: 0x0fc389)
    static let b_BuildSuccessLight = b_BuildSuccess.opacity(0.16)
    static let b_BuildRunning = Color(hex: 0x683d87)
    static let b_BuildRunningLight = b_BuildRunning.opacity(0.16)
    
    static let b_Primary = Color(red: 0.29, green: 0.18, blue: 0.36)
    static let b_PrimaryLight = Color(red: 0.29, green: 0.18, blue: 0.36).opacity(0.6)
    static let b_ButtonPrimary = Color(hex: 0x450674)
    static let b_ButtonPrimaryLight = Color(hex: 0x6c0eb2)
    static let b_BorderLight = Color(red: 0.87, green: 0.87, blue: 0.87)
    static let b_ShadowLight = Color(red: 0, green: 0, blue: 0, opacity: 0.10)
    static let b_LogsBackground = Color(hex: 0x2c3e50)
    static let b_LogsDefault = Color(hex: 0xececec)
    
    static let b_StringColors = [0x68442c, 0x86d641, 0xa775db, 0xdf5ac3, 0x46bee8, 0x63c99a, 0x19937c, 0xed544c, 0xff931e, 0x107ec1, 0x48e1ed, 0x743da5, 0xf9d128, 0xff931e, 0x9e4b39, 0xb51c98, 0xb20202, 0xbf8a66, 0x2c3f50, 0x441f62, 0x0c5b4c, 0x391401, 0x27ae61, 0xef7bef]
        .map({ Color(hex: $0) })
    
    static func fromString(_ str: String) -> Color {
        let str = str.uppercased()
        let seed = [str.first, str.last].compactMap({ $0?.unicodeScalars.first?.value }).map({ Int($0) }).reduce(0, +)
        if seed > 0 {
            return Color.b_StringColors[seed % Color.b_StringColors.count]
        }
        return .white
    }
}

extension BuildResponseItemModel.Status {
    var color: Color {
        switch self {
        case .running:
            return Color.b_BuildRunning
        case .success:
            return Color.b_BuildSuccess
        case .error:
            return Color.b_BuildFailed
        case .aborted:
            return Color.b_BuildAborted
        }
    }
    var colorLight: Color {
        switch self {
        case .running:
            return Color.b_BuildRunningLight
        case .success:
            return Color.b_BuildSuccessLight
        case .error:
            return Color.b_BuildFailedLight
        case .aborted:
            return Color.b_BuildAbortedLight
        }
    }
}
