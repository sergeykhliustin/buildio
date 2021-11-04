//
//  BuildResponseItemModel+Additions.swift
//  Buildio
//
//  Created by Sergey Khliustin on 04.11.2021.
//

import Foundation
import Models

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
}
