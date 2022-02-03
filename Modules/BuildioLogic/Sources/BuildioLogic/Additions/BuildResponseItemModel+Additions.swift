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
    
    public var durationString: String? {
        return duration?.stringFromTimeInterval()
    }
    
    public var branchFromToUIString: String {
        if let pullRequestTargetBranch = pullRequestTargetBranch {
            return "\(branch) → \(pullRequestTargetBranch)"
        }
        return branch
    }
    
    public var branchOrigOwnerUIString: String {
        if case .string(let owner) = originalBuildParams["branch_repo_owner"] {
            return [owner, branch].joined(separator: ":")
        }
        return branch
    }
    
    public var extendedStatus: ExtendedStatus {
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
    
    public enum ExtendedStatus: String {
        case onHold = "On hold"
        case waitingForWorker = "Waiting for worker"
        case running = "Running"
        case success = "Success"
        case error = "Failed"
        case aborted = "Aborted"
        case cancelled = "Cancelled"
        
        public var color: Color {
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
        
        public var colorLight: Color {
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
