//
// V0OrganizationDataModel.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation


public struct V0OrganizationDataModel: Codable, Hashable {

    public var avatarIconUrl: String?
    public var concurrencyCount: Int?
    public var name: String?
    public var owners: [V0OrganizationOwner]?
    public var slug: String?

    public init(avatarIconUrl: String? = nil, concurrencyCount: Int? = nil, name: String? = nil, owners: [V0OrganizationOwner]? = nil, slug: String? = nil) {
        self.avatarIconUrl = avatarIconUrl
        self.concurrencyCount = concurrencyCount
        self.name = name
        self.owners = owners
        self.slug = slug
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case avatarIconUrl = "avatar_icon_url"
        case concurrencyCount = "concurrency_count"
        case name
        case owners
        case slug
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(avatarIconUrl, forKey: .avatarIconUrl)
        try container.encodeIfPresent(concurrencyCount, forKey: .concurrencyCount)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(owners, forKey: .owners)
        try container.encodeIfPresent(slug, forKey: .slug)
    }
}

