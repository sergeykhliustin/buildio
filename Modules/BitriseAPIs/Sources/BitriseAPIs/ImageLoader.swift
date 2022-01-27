//
//  ImageLoader.swift
//  Buildio
//
//  Created by Sergey Khliustin on 04.11.2021.
//

import Foundation
import Combine
import UIKit

public final class ImageLoader {
    private static let cacheURL: URL? = {
        let arrayPaths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return arrayPaths.first
    }()
    
    public init() { }
    
    public func image(_ url: URL?) async throws -> UIImage {    
        guard let url = url else {
            throw ErrorResponse.error(0, nil, nil, DownloadException.requestMissingURL)
        }
        let sha = url.sha256
        if let cacheURL = Self.cacheURL,
           let data = try? Data(contentsOf: cacheURL.appendingPathComponent(sha)), let image = UIImage(data: data) {
            return image
        }
        
        do {
            let data = try Data(contentsOf: url)
            let image = UIImage(data: data)!
            if let cacheURL = Self.cacheURL {
                try? data.write(to: cacheURL.appendingPathComponent(sha))
            }
            return image
        } catch {
            throw ErrorResponse.error(0, nil, nil, error)
        }
    }
    
    public func image(_ url: URL?) -> AnyPublisher<UIImage, ErrorResponse> {
        return Future<UIImage, ErrorResponse> { promise in
            guard let url = url else {
                return promise(.failure(ErrorResponse.error(0, nil, nil, DownloadException.requestMissingURL)))
            }
            let sha = url.sha256
            if let cacheURL = Self.cacheURL,
                let data = try? Data(contentsOf: cacheURL.appendingPathComponent(sha)), let image = UIImage(data: data) {
                return promise(.success(image))
            }
            
            do {
                let data = try Data(contentsOf: url)
                let image = UIImage(data: data)!
                if let cacheURL = Self.cacheURL {
                    try? data.write(to: cacheURL.appendingPathComponent(sha))
                }
                return promise(.success(image))
            } catch {
                return promise(.failure(ErrorResponse.error(0, nil, nil, error)))
            }
        }
        .eraseToAnyPublisher()
    }
}
