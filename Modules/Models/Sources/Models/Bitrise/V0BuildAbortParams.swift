//
// V0BuildAbortParams.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

public struct V0BuildAbortParams: Codable {

    public var abortReason: String
    public var abortWithSuccess: Bool
    public var skipNotifications: Bool

    public init(abortReason: String, abortWithSuccess: Bool, skipNotifications: Bool) {
        self.abortReason = abortReason
        self.abortWithSuccess = abortWithSuccess
        self.skipNotifications = skipNotifications
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case abortReason = "abort_reason"
        case abortWithSuccess = "abort_with_success"
        case skipNotifications = "skip_notifications"
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(abortReason, forKey: .abortReason)
        try container.encode(abortWithSuccess, forKey: .abortWithSuccess)
        try container.encode(skipNotifications, forKey: .skipNotifications)
    }
}
