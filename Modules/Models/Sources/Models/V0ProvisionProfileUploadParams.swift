//
// V0ProvisionProfileUploadParams.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

public struct V0ProvisionProfileUploadParams: Codable, Hashable {

    public var uploadFileName: String
    public var uploadFileSize: Int

    public init(uploadFileName: String, uploadFileSize: Int) {
        self.uploadFileName = uploadFileName
        self.uploadFileSize = uploadFileSize
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case uploadFileName = "upload_file_name"
        case uploadFileSize = "upload_file_size"
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uploadFileName, forKey: .uploadFileName)
        try container.encode(uploadFileSize, forKey: .uploadFileSize)
    }
}