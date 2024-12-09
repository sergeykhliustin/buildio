//
// V0BuildAbortResponseModel.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

public struct V0BuildAbortResponseModel: Codable, Sendable {

    public let status: String?

    public init(status: String? = nil) {
        self.status = status
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case status
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(status, forKey: .status)
    }
}
