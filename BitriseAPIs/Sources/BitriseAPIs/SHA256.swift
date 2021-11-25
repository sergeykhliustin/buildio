//
//  SHA256.swift
//  Buildio
//
//  Created by Sergey Khliustin on 29.10.2021.
//

import Foundation
import CryptoKit

extension SHA256Digest {
    var string: String {
        return description.replacingOccurrences(of: "SHA256 digest: ", with: "")
    }
}

protocol SHA256Convertable {
    var sha256: String { get }
}

extension Data: SHA256Convertable {
    var sha256: String {
        return SHA256.hash(data: self).string
    }
}

extension String: SHA256Convertable {
    var sha256: String {
        return SHA256.hash(data: self.data(using: .utf8)!).string
    }
}

extension URL: SHA256Convertable {
    var sha256: String {
        return absoluteString.sha256
    }
}

extension Dictionary: SHA256Convertable where Key == String, Value == String {
    var sha256: String {
        var data: [String] = keys.sorted()
        data.append(contentsOf: values.sorted())
        return data.joined().sha256
    }
}

extension URLRequest: SHA256Convertable {
    var sha256: String {
        
        return [url?.sha256, self.httpBody?.sha256, self.allHTTPHeaderFields?.sha256].compactMap({ $0 }).joined().sha256
    }
}
