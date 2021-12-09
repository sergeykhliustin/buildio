//
//  BuildResponseItemModel+Additions.swift
//  Buildio
//
//  Created by Sergey Khliustin on 04.11.2021.
//

import Foundation
import Models
import SwiftUI

extension BuildResponseItemModel {
    var duration: TimeInterval? {
        guard let startDate = environmentPrepareFinishedAt else { return nil }
        let finishDate = finishedAt ?? Date()
        return startDate.distance(to: finishDate)
    }
    
    var durationString: String? {
        return duration?.stringFromTimeInterval()
    }
    
    var branchUIString: String {
        if let pullRequestTargetBranch = pullRequestTargetBranch {
            return "\(branch) → \(pullRequestTargetBranch)"
        }
        return branch
    }
    
    var extendedStatus: ExtendedStatus {
        switch status {
        case .running:
            return isOnHold ? .onHold : environmentPrepareFinishedAt == nil ? .waitingForWorker : .running
        case .success:
            return .success
        case .error:
            return .error
        case .aborted:
            return .aborted
        case .cancelled:
            return .cancelled
        }
    }
    
    enum ExtendedStatus: String {
        case onHold = "On hold"
        case waitingForWorker = "Waiting for worker"
        case running = "Running"
        case success = "Success"
        case error = "Failed"
        case aborted = "Aborted"
        case cancelled = "Cancelled"
        
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
}
