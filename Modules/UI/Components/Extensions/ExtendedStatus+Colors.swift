//
//  ExtendedStatus+Colors.swift
//  Modules
//
//  Created by Sergii Khliustin on 05.11.2024.
//

import Foundation
import SwiftUI
import Models
import Assets

package extension BuildResponseItemModel.ExtendedStatus {
    var color: Color {
        switch self {
        case .onHold:
            return .b_BuildOnHold
        case .waitingForWorker, .running:
            return .b_BuildRunning
        case .success:
            return .b_BuildSuccess
        case .error:
            return .b_BuildFailed
        case .aborted, .cancelled:
            return .b_BuildAborted
        }
    }

    var colorLight: Color {
        switch self {
        case .onHold:
            return .b_BuildOnHoldLight
        case .waitingForWorker, .running:
            return .b_BuildRunningLight
        case .success:
            return .b_BuildSuccessLight
        case .error:
            return .b_BuildFailedLight
        case .aborted, .cancelled:
            return .b_BuildAbortedLight
        }
    }
}
