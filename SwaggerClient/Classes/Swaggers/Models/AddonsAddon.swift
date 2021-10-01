//
// AddonsAddon.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct AddonsAddon: Codable {

    public var bannerImage: String?
    public var cardHeaderColors: [String]?
    public var categories: [String]?
    public var _description: String?
    public var developerLinks: [AddonsDeveloperLink]?
    public var documentationUrl: String?
    public var hasUi: Bool?
    public var icon: String?
    public var _id: String?
    public var isBeta: Bool?
    public var plans: [AddonsPlan]?
    public var platforms: [String]?
    public var previewImages: [String]?
    public var setupGuide: AddonsSetupGuide?
    public var subtitle: String?
    public var summary: String?
    public var title: String?

    public init(bannerImage: String? = nil, cardHeaderColors: [String]? = nil, categories: [String]? = nil, _description: String? = nil, developerLinks: [AddonsDeveloperLink]? = nil, documentationUrl: String? = nil, hasUi: Bool? = nil, icon: String? = nil, _id: String? = nil, isBeta: Bool? = nil, plans: [AddonsPlan]? = nil, platforms: [String]? = nil, previewImages: [String]? = nil, setupGuide: AddonsSetupGuide? = nil, subtitle: String? = nil, summary: String? = nil, title: String? = nil) {
        self.bannerImage = bannerImage
        self.cardHeaderColors = cardHeaderColors
        self.categories = categories
        self._description = _description
        self.developerLinks = developerLinks
        self.documentationUrl = documentationUrl
        self.hasUi = hasUi
        self.icon = icon
        self._id = _id
        self.isBeta = isBeta
        self.plans = plans
        self.platforms = platforms
        self.previewImages = previewImages
        self.setupGuide = setupGuide
        self.subtitle = subtitle
        self.summary = summary
        self.title = title
    }

    public enum CodingKeys: String, CodingKey { 
        case bannerImage = "banner_image"
        case cardHeaderColors = "card_header_colors"
        case categories
        case _description = "description"
        case developerLinks = "developer_links"
        case documentationUrl = "documentation_url"
        case hasUi = "has_ui"
        case icon
        case _id = "id"
        case isBeta = "is_beta"
        case plans
        case platforms
        case previewImages = "preview_images"
        case setupGuide = "setup_guide"
        case subtitle
        case summary
        case title
    }

}
