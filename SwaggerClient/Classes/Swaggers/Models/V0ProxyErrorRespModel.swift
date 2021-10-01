//
// V0ProxyErrorRespModel.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct V0ProxyErrorRespModel: Codable {

    public var errorMsg: String?

    public init(errorMsg: String? = nil) {
        self.errorMsg = errorMsg
    }

    public enum CodingKeys: String, CodingKey { 
        case errorMsg = "error_msg"
    }

}
