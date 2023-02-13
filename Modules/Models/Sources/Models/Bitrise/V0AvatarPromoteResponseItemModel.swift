//
// V0AvatarPromoteResponseItemModel.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

public struct V0AvatarPromoteResponseItemModel: Codable {

    public var isCandidate: Bool?
    public var slug: String?
    public var uploadFileName: String?
    public var uploadFileSize: Int?

    public init(isCandidate: Bool? = nil, slug: String? = nil, uploadFileName: String? = nil, uploadFileSize: Int? = nil) {
        self.isCandidate = isCandidate
        self.slug = slug
        self.uploadFileName = uploadFileName
        self.uploadFileSize = uploadFileSize
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case isCandidate = "is_candidate"
        case slug
        case uploadFileName = "upload_file_name"
        case uploadFileSize = "upload_file_size"
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(isCandidate, forKey: .isCandidate)
        try container.encodeIfPresent(slug, forKey: .slug)
        try container.encodeIfPresent(uploadFileName, forKey: .uploadFileName)
        try container.encodeIfPresent(uploadFileSize, forKey: .uploadFileSize)
    }
}
