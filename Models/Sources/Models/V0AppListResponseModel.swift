//
// V0AppListResponseModel.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

public struct V0AppListResponseModel: Codable, Hashable, PagingResponseModel {

    public var data: [V0AppResponseItemModel]
    public var paging: V0PagingResponseModel

    public init(data: [V0AppResponseItemModel] = [], paging: V0PagingResponseModel) {
        self.data = data
        self.paging = paging
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case data
        case paging
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(data, forKey: .data)
        try container.encodeIfPresent(paging, forKey: .paging)
    }
}
