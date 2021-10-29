//
//  URLRequest+Cache.swift
//  Buildio
//
//  Created by severehed on 29.10.2021.
//

import Foundation

extension URLRequest {
    var cacheURL: URL {
        let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
        let key = self.url!.absoluteString.MD5() + (self.httpBody?.MD5() ?? "") + (self.allHTTPHeaderFields?.MD5() ?? "")
        return URL(fileURLWithPath: (cachePath as NSString).appendingPathComponent("\(key).urlrequestcache"))
    }
    
    func getCache() -> (data: Data?, response: URLResponse?, error: Error?)? {
        if ProcessInfo.processInfo.environment["USE_URL_CACHE"] == "true" {
            do {
                let data = try Data(contentsOf: cacheURL)
                let response = HTTPURLResponse(url: url!, statusCode: 200, httpVersion: nil, headerFields: nil)
                return (data, response, nil)
            } catch {
                logger.error(error)
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
            logger.error(error)
        }
    }
}
