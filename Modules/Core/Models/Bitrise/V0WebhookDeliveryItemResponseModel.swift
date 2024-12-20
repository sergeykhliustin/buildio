//
// V0WebhookDeliveryItemResponseModel.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

public struct V0WebhookDeliveryItemResponseModel: Codable {

    public let createdAt: String?
    public let requestHeaders: String?
    public let requestPayload: String?
    public let requestUrl: String?
    public let responseBody: String?
    public let responseHeaders: String?
    public let responseHttpStatus: Int?
    public let responseSeconds: Int?
    public let slug: String?
    public let updatedAt: String?

    public init(createdAt: String? = nil, requestHeaders: String? = nil, requestPayload: String? = nil, requestUrl: String? = nil, responseBody: String? = nil, responseHeaders: String? = nil, responseHttpStatus: Int? = nil, responseSeconds: Int? = nil, slug: String? = nil, updatedAt: String? = nil) {
        self.createdAt = createdAt
        self.requestHeaders = requestHeaders
        self.requestPayload = requestPayload
        self.requestUrl = requestUrl
        self.responseBody = responseBody
        self.responseHeaders = responseHeaders
        self.responseHttpStatus = responseHttpStatus
        self.responseSeconds = responseSeconds
        self.slug = slug
        self.updatedAt = updatedAt
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case requestHeaders = "request_headers"
        case requestPayload = "request_payload"
        case requestUrl = "request_url"
        case responseBody = "response_body"
        case responseHeaders = "response_headers"
        case responseHttpStatus = "response_http_status"
        case responseSeconds = "response_seconds"
        case slug
        case updatedAt = "updated_at"
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(requestHeaders, forKey: .requestHeaders)
        try container.encodeIfPresent(requestPayload, forKey: .requestPayload)
        try container.encodeIfPresent(requestUrl, forKey: .requestUrl)
        try container.encodeIfPresent(responseBody, forKey: .responseBody)
        try container.encodeIfPresent(responseHeaders, forKey: .responseHeaders)
        try container.encodeIfPresent(responseHttpStatus, forKey: .responseHttpStatus)
        try container.encodeIfPresent(responseSeconds, forKey: .responseSeconds)
        try container.encodeIfPresent(slug, forKey: .slug)
        try container.encodeIfPresent(updatedAt, forKey: .updatedAt)
    }
}
