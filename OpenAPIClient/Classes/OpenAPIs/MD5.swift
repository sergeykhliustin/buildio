//
//  MD5.swift
//  Buildio
//
//  Created by severehed on 29.10.2021.
//

import Foundation

import Foundation
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

extension String {
    func MD5() -> String {
        return self.data(using: .utf8)!.MD5()
    }
}

extension Data {
    func MD5() -> String {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = self
        var digestData = Data(count: length)
        
        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        
        var digestHex = ""
        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digestData[index])
        }
        
        return digestHex
    }
}

extension Dictionary where Key == String, Value == String {
    func MD5() -> String {
        var data: [String] = keys.sorted()
        data.append(contentsOf: values.sorted())
        return data.joined().MD5()
    }
}
