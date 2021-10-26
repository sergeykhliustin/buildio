//
// V0AppFinishRespModel.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation


public struct V0AppFinishRespModel: Codable, Hashable {

    public var branchName: String?
    public var buildTriggerToken: String?
    public var isWebhookAutoRegSupported: Bool?
    public var status: String?

    public init(branchName: String? = nil, buildTriggerToken: String? = nil, isWebhookAutoRegSupported: Bool? = nil, status: String? = nil) {
        self.branchName = branchName
        self.buildTriggerToken = buildTriggerToken
        self.isWebhookAutoRegSupported = isWebhookAutoRegSupported
        self.status = status
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case branchName = "branch_name"
        case buildTriggerToken = "build_trigger_token"
        case isWebhookAutoRegSupported = "is_webhook_auto_reg_supported"
        case status
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(branchName, forKey: .branchName)
        try container.encodeIfPresent(buildTriggerToken, forKey: .buildTriggerToken)
        try container.encodeIfPresent(isWebhookAutoRegSupported, forKey: .isWebhookAutoRegSupported)
        try container.encodeIfPresent(status, forKey: .status)
    }
}

