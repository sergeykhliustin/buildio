//
// AddonsSetupInstruction.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

public struct AddonsSetupInstruction: Codable {

    public let cardContent: String?
    public let description: String?
    public let type: String?

    public init(cardContent: String? = nil, description: String? = nil, type: String? = nil) {
        self.cardContent = cardContent
        self.description = description
        self.type = type
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case cardContent = "card_content"
        case description
        case type
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(cardContent, forKey: .cardContent)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(type, forKey: .type)
    }
}
