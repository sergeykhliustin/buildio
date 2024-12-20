//
// V0AppWebhookUpdateParams.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

public struct V0AppWebhookUpdateParams: Codable {

    public let events: [String]
    public let headers: [Int]?
    public let url: String

    public init(events: [String], headers: [Int]? = nil, url: String) {
        self.events = events
        self.headers = headers
        self.url = url
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case events
        case headers
        case url
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(events, forKey: .events)
        try container.encodeIfPresent(headers, forKey: .headers)
        try container.encode(url, forKey: .url)
    }
}
