//
//  File.swift
//  
//
//  Created by Sergey Khliustin on 01.11.2021.
//

import Foundation

public struct BuildLogResponseModel: Codable {
    public let logChunks: [LogChunk]
    public let nextBeforeTimestamp: String
    public let nextAfterTimestamp: String
    public let isArchived: Bool
    public let expiringRawLogUrl: String?
    
    public struct LogChunk: Codable {
        public let chunk: String
        public let position: Int

        public init(chunk: String, position: Int) {
            self.chunk = chunk
            self.position = position
        }
    }
}
