//
//  ExtendedStatus.swift
//  Modules
//
//  Created by Sergii Khliustin on 03.11.2024.
//

import Foundation

package extension BuildResponseItemModel {
    var progress: Double? {
        if let estimatedDuration = estimatedDuration,
           let duration = duration,
           status == .running {
            return min(duration / estimatedDuration, 0.99)
        }
        return nil
    }

    var duration: TimeInterval? {
        guard let startDate = environmentPrepareFinishedAt else { return nil }
        let finishDate = finishedAt ?? Date()
        return startDate.distance(to: finishDate)
    }
    
    var durationString: String? {
        return duration?.stringFromTimeInterval()
    }
    
    var branchFromToUIString: String {
        if let pullRequestTargetBranch, let branch {
            return "\(branch) → \(pullRequestTargetBranch)"
        } else if let tag, !tag.isEmpty {
            return ""
        }
        return branch ?? ""
    }
    
    var branchOrigOwnerUIString: String {
        if case .string(let owner) = originalBuildParams["branch_repo_owner"] {
            return [owner, branch ?? ""].joined(separator: ":")
        }
        return branch ?? ""
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
    }
}
