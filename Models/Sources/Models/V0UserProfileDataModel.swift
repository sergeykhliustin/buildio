//
// V0UserProfileDataModel.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

public struct V0UserProfileDataModel: Codable, Hashable {

    public var avatarUrl: String?
    public var createdAt: String?
    public var dataId: Int?
    public var email: String?
    public var hasUsedOrganizationTrial: Bool?
    public var paymentProcessor: String?
    public var slug: String?
    public var unconfirmedEmail: String?
    public var username: String?

    public init(avatarUrl: String? = nil, createdAt: String? = nil, dataId: Int? = nil, email: String? = nil, hasUsedOrganizationTrial: Bool? = nil, paymentProcessor: String? = nil, slug: String? = nil, unconfirmedEmail: String? = nil, username: String? = nil) {
        self.avatarUrl = avatarUrl
        self.createdAt = createdAt
        self.dataId = dataId
        self.email = email
        self.hasUsedOrganizationTrial = hasUsedOrganizationTrial
        self.paymentProcessor = paymentProcessor
        self.slug = slug
        self.unconfirmedEmail = unconfirmedEmail
        self.username = username
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case avatarUrl = "avatar_url"
        case createdAt = "created_at"
        case dataId = "data_id"
        case email
        case hasUsedOrganizationTrial = "has_used_organization_trial"
        case paymentProcessor = "payment_processor"
        case slug
        case unconfirmedEmail = "unconfirmed_email"
        case username
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(avatarUrl, forKey: .avatarUrl)
        try container.encodeIfPresent(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(dataId, forKey: .dataId)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(hasUsedOrganizationTrial, forKey: .hasUsedOrganizationTrial)
        try container.encodeIfPresent(paymentProcessor, forKey: .paymentProcessor)
        try container.encodeIfPresent(slug, forKey: .slug)
        try container.encodeIfPresent(unconfirmedEmail, forKey: .unconfirmedEmail)
        try container.encodeIfPresent(username, forKey: .username)
    }
}