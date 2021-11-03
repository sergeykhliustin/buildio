//
//  URLRequest+Cache.swift
//  Buildio
//
//  Created by Sergey Khliustin on 29.10.2021.
//

import Foundation

extension URLRequest {
    var cacheURL: URL {
        let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
        return URL(fileURLWithPath: (cachePath as NSString).appendingPathComponent("\(sha256).urlrequestcache"))
    }
    
    func getCache() -> (data: Data?, response: URLResponse?, error: Error?)? {
        if ProcessInfo.processInfo.environment["USE_URL_CACHE"] == "true" {
            do {
                let data = try Data(contentsOf: cacheURL)
                let response = HTTPURLResponse(url: url!, statusCode: 200, httpVersion: nil, headerFields: nil)
                return (data, response, nil)
            } catch {
                logger.debug(error)
            }
        }
        return nil
    }
    
    func saveCache(data: Data) {
        if ProcessInfo.processInfo.environment["USE_URL_CACHE"] != "true" {
            let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
            if let contents = try? FileManager.default.contentsOfDirectory(atPath: cachePath) {
                for content in contents {
                    if content.hasSuffix(".urlrequestcache") {
                        try? FileManager.default.removeItem(atPath: (cachePath as NSString).appendingPathComponent(content))
                    }
                }
            }
        }
        guard ProcessInfo.processInfo.environment["USE_URL_CACHE"] == "true" else { return }
        
        do {
            try data.write(to: cacheURL)
        } catch {
            logger.debug(error)
        }
    }
}
