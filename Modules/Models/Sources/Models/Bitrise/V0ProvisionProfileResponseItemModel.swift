//
// V0ProvisionProfileResponseItemModel.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

public struct V0ProvisionProfileResponseItemModel: Codable {

    public var downloadUrl: String?
    public var isExpose: Bool?
    public var isProtected: Bool?
    public var processed: Bool?
    public var slug: String?
    public var uploadFileName: String?
    public var uploadFileSize: Int?
    public var uploadUrl: String?

    public init(downloadUrl: String? = nil, isExpose: Bool? = nil, isProtected: Bool? = nil, processed: Bool? = nil, slug: String? = nil, uploadFileName: String? = nil, uploadFileSize: Int? = nil, uploadUrl: String? = nil) {
        self.downloadUrl = downloadUrl
        self.isExpose = isExpose
        self.isProtected = isProtected
        self.processed = processed
        self.slug = slug
        self.uploadFileName = uploadFileName
        self.uploadFileSize = uploadFileSize
        self.uploadUrl = uploadUrl
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case downloadUrl = "download_url"
        case isExpose = "is_expose"
        case isProtected = "is_protected"
        case processed
        case slug
        case uploadFileName = "upload_file_name"
        case uploadFileSize = "upload_file_size"
        case uploadUrl = "upload_url"
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(downloadUrl, forKey: .downloadUrl)
        try container.encodeIfPresent(isExpose, forKey: .isExpose)
        try container.encodeIfPresent(isProtected, forKey: .isProtected)
        try container.encodeIfPresent(processed, forKey: .processed)
        try container.encodeIfPresent(slug, forKey: .slug)
        try container.encodeIfPresent(uploadFileName, forKey: .uploadFileName)
        try container.encodeIfPresent(uploadFileSize, forKey: .uploadFileSize)
        try container.encodeIfPresent(uploadUrl, forKey: .uploadUrl)
    }
}
