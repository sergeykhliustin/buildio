//
//  File.swift
//  
//
//  Created by severehed on 01.11.2021.
//

import Foundation

public struct BuildLogResponseModel: Codable {
    public let logChunks: [LogChunk]
    public let nextBeforeTimestamp: Date
    public let nextAfterTimestamp: Date
    public let isArchived: Bool
    public let expiringRawLogUrl: String?

    public init(logChunks: [LogChunk], nextBeforeTimestamp: Date, nextAfterTimestamp: Date, isArchived: Bool, expiringRawLogUrl: String?) {
        self.logChunks = logChunks
        self.nextBeforeTimestamp = nextBeforeTimestamp
        self.nextAfterTimestamp = nextAfterTimestamp
        self.isArchived = isArchived
        self.expiringRawLogUrl = expiringRawLogUrl
    }
    
    public struct LogChunk: Codable {
        public let chunk: String
        public let position: Int

        public init(chunk: String, position: Int) {
            self.chunk = chunk
            self.position = position
        }
    }
}
