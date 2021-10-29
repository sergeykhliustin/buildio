//
// V0BuildListAllResponseItemModel.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

public struct V0BuildListAllResponseItemModel: Codable, Hashable {

    public var abortReason: String?
    public var branch: String
    public var buildNumber: Int
    public var commitHash: String?
    public var commitMessage: String?
    public var commitViewUrl: String?
    public var creditCost: Int?
    public var environmentPrepareFinishedAt: Date
    public var finishedAt: Date?
    public var isOnHold: Bool
    public var isProcessed: Bool
    public var machineTypeId: String
    public var originalBuildParams: [String: JSONValue]
    public var pullRequestId: Int?
    public var pullRequestTargetBranch: String?
    public var pullRequestViewUrl: String?
    public var repository: V0AppResponseItemModel?
    public var slug: String
    public var stackIdentifier: String
    public var startedOnWorkerAt: Date
    public var status: Status
    public var statusText: String
    public var tag: String?
    public var triggeredAt: Date
    public var triggeredBy: String?
    public var triggeredWorkflow: String
    
    public init(abortReason: String? = nil,
                branch: String,
                buildNumber: Int,
                commitHash: String? = nil,
                commitMessage: String? = nil,
                commitViewUrl: String? = nil,
                creditCost: Int? = nil,
                environmentPrepareFinishedAt: Date,
                finishedAt: Date? = nil,
                isOnHold: Bool,
                isProcessed: Bool,
                machineTypeId: String,
                originalBuildParams: [String: JSONValue],
                pullRequestId: Int? = nil,
                pullRequestTargetBranch: String? = nil,
                pullRequestViewUrl: String? = nil,
                repository: V0AppResponseItemModel,
                slug: String,
                stackIdentifier: String,
                startedOnWorkerAt: Date,
                status: Status,
                statusText: String,
                tag: String? = nil,
                triggeredAt: Date,
                triggeredBy: String? = nil,
                triggeredWorkflow: String) {
        self.abortReason = abortReason
        self.branch = branch
        self.buildNumber = buildNumber
        self.commitHash = commitHash
        self.commitMessage = commitMessage
        self.commitViewUrl = commitViewUrl
        self.creditCost = creditCost
        self.environmentPrepareFinishedAt = environmentPrepareFinishedAt
        self.finishedAt = finishedAt
        self.isOnHold = isOnHold
        self.isProcessed = isProcessed
        self.machineTypeId = machineTypeId
        self.originalBuildParams = originalBuildParams
        self.pullRequestId = pullRequestId
        self.pullRequestTargetBranch = pullRequestTargetBranch
        self.pullRequestViewUrl = pullRequestViewUrl
        self.repository = repository
        self.slug = slug
        self.stackIdentifier = stackIdentifier
        self.startedOnWorkerAt = startedOnWorkerAt
        self.status = status
        self.statusText = statusText
        self.tag = tag
        self.triggeredAt = triggeredAt
        self.triggeredBy = triggeredBy
        self.triggeredWorkflow = triggeredWorkflow
    }
    
    
    @frozen public enum Status: Int, Codable {
        case running = 0
        case success = 1
        case error = 2
        case aborted = 3
    }
    
    public static func preview() -> Self {
        return V0BuildListAllResponseItemModel(
            abortReason: nil,
            branch: "branch",
            buildNumber: 1,
            commitHash: nil,
            commitMessage: nil,
            commitViewUrl: nil,
            creditCost: nil,
            environmentPrepareFinishedAt: Date(),
            finishedAt: nil,
            isOnHold: false,
            isProcessed: true,
            machineTypeId: "machineTypeId",
            originalBuildParams: [:],
            pullRequestId: nil,
            pullRequestTargetBranch: nil,
            pullRequestViewUrl: nil,
            repository: V0AppResponseItemModel.preview(),
            slug: "slug",
            stackIdentifier: "stackIdentifier",
            startedOnWorkerAt: Date(),
            status: .success,
            statusText: "success",
            tag: nil,
            triggeredAt: Date(),
            triggeredBy: nil,
            triggeredWorkflow: "triggeredWorkflow")
    }
}
