//
// V0AppAddOnResponseItemModel.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

public struct V0AppAddOnResponseItemModel: Codable {

    public let description: String?
    public let documentationUrl: String?
    public let hasUi: Bool?
    public let icon: String?
    public let id: String?
    public let isBeta: Bool?
    public let isEnabled: Bool?
    public let loginUrl: String?
    public let plan: AddonsPlan?
    public let scopes: [String]?
    public let setupGuide: AddonsSetupGuide?
    public let summary: String?
    public let termsUrl: String?
    public let title: String?

    public init(description: String? = nil, documentationUrl: String? = nil, hasUi: Bool? = nil, icon: String? = nil, id: String? = nil, isBeta: Bool? = nil, isEnabled: Bool? = nil, loginUrl: String? = nil, plan: AddonsPlan? = nil, scopes: [String]? = nil, setupGuide: AddonsSetupGuide? = nil, summary: String? = nil, termsUrl: String? = nil, title: String? = nil) {
        self.description = description
        self.documentationUrl = documentationUrl
        self.hasUi = hasUi
        self.icon = icon
        self.id = id
        self.isBeta = isBeta
        self.isEnabled = isEnabled
        self.loginUrl = loginUrl
        self.plan = plan
        self.scopes = scopes
        self.setupGuide = setupGuide
        self.summary = summary
        self.termsUrl = termsUrl
        self.title = title
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case description
        case documentationUrl = "documentation_url"
        case hasUi = "has_ui"
        case icon
        case id
        case isBeta = "is_beta"
        case isEnabled = "is_enabled"
        case loginUrl = "login_url"
        case plan
        case scopes
        case setupGuide = "setup_guide"
        case summary
        case termsUrl = "terms_url"
        case title
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(documentationUrl, forKey: .documentationUrl)
        try container.encodeIfPresent(hasUi, forKey: .hasUi)
        try container.encodeIfPresent(icon, forKey: .icon)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(isBeta, forKey: .isBeta)
        try container.encodeIfPresent(isEnabled, forKey: .isEnabled)
        try container.encodeIfPresent(loginUrl, forKey: .loginUrl)
        try container.encodeIfPresent(plan, forKey: .plan)
        try container.encodeIfPresent(scopes, forKey: .scopes)
        try container.encodeIfPresent(setupGuide, forKey: .setupGuide)
        try container.encodeIfPresent(summary, forKey: .summary)
        try container.encodeIfPresent(termsUrl, forKey: .termsUrl)
        try container.encodeIfPresent(title, forKey: .title)
    }
}
