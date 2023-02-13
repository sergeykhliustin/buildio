//
// V0AppleAPICredentialResponseItem.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

public struct V0AppleAPICredentialResponseItem: Codable {

    public var createdAt: String?
    public var issuerId: String?
    public var keyId: String?
    public var name: String?
    public var slug: String?
    public var updatedAt: String?

    public init(createdAt: String? = nil, issuerId: String? = nil, keyId: String? = nil, name: String? = nil, slug: String? = nil, updatedAt: String? = nil) {
        self.createdAt = createdAt
        self.issuerId = issuerId
        self.keyId = keyId
        self.name = name
        self.slug = slug
        self.updatedAt = updatedAt
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case issuerId = "issuer_id"
        case keyId = "key_id"
        case name
        case slug
        case updatedAt = "updated_at"
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(issuerId, forKey: .issuerId)
        try container.encodeIfPresent(keyId, forKey: .keyId)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(slug, forKey: .slug)
        try container.encodeIfPresent(updatedAt, forKey: .updatedAt)
    }
}
