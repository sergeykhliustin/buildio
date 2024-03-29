//
// V0PlanDataModel.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

public struct V0PlanDataModel: Codable {

    public var containerCount: Int?
    public var expiresAt: String?
    public var id: String?
    public var name: String?
    public var price: Int?

    public init(containerCount: Int? = nil, expiresAt: String? = nil, id: String? = nil, name: String? = nil, price: Int? = nil) {
        self.containerCount = containerCount
        self.expiresAt = expiresAt
        self.id = id
        self.name = name
        self.price = price
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case containerCount = "container_count"
        case expiresAt = "expires_at"
        case id
        case name
        case price
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(containerCount, forKey: .containerCount)
        try container.encodeIfPresent(expiresAt, forKey: .expiresAt)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(price, forKey: .price)
    }
}
