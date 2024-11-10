//
// V0AppConfigRequestParam.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

public struct V0AppConfigRequestParam: Codable {

    public var appConfigDatastoreYaml: String

    public init(appConfigDatastoreYaml: String) {
        self.appConfigDatastoreYaml = appConfigDatastoreYaml
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case appConfigDatastoreYaml = "app_config_datastore_yaml"
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(appConfigDatastoreYaml, forKey: .appConfigDatastoreYaml)
    }
}