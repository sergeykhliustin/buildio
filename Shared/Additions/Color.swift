//
//  Color.swift
//  Buildio
//
//  Created by severehed on 21.10.2021.
//

import SwiftUI
import Models

extension Color {
    static let b_BuildFailed = Color(hex: 0xff2158)
    static let b_BuildFailedLight = b_BuildFailed.opacity(0.16)
    static let b_BuildAborted = Color(hex: 0xffc500)
    static let b_BuildAbortedLight = b_BuildAborted.opacity(0.16)
    static let b_BuildSuccess = Color(hex: 0x0fc389)
    static let b_BuildSuccessLight = b_BuildSuccess.opacity(0.16)
    static let b_BuildRunning = Color(hex: 0x683d87)
    static let b_BuildRunningLight = b_BuildRunning.opacity(0.16)
    
    static let b_Primary = Color(red: 0.29, green: 0.18, blue: 0.36)
    static let b_ButtonPrimary = Color(hex: 0x450674)
    static let b_ButtonPrimaryLight = Color(hex: 0x6c0eb2)
    static let b_BorderLight = Color(red: 0.87, green: 0.87, blue: 0.87)
    static let b_ShadowLight = Color(red: 0, green: 0, blue: 0, opacity: 0.10)
    static let b_LogsBackground = Color(hex: 0x2c3e50)
    static let b_LogsDefault = Color(hex: 0xececec)
}

extension V0BuildResponseItemModel.Status {
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
}

extension V0AppResponseItemModel.Status {
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
}
