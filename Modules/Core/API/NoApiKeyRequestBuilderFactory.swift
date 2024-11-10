//
//  NoApiKeyRequestBuilderFactory.swift
//  
//
//  Created by Sergey Khliustin on 22.12.2021.
//

import Foundation

final class NoApiKeyRequestBuilderFactory: RequestBuilderFactory {
    func getNonDecodableBuilder<T>() -> RequestBuilder<T>.Type {
        return EmptyRequestBuilder<T>.self
    }
    
    func getBuilder<T: Codable>() -> RequestBuilder<T>.Type {
        return EmptyRequestBuilder<T>.self
    }
}

final class EmptyRequestBuilder<T>: RequestBuilder<T> {
    override func executeCompletion(_ completion: @escaping (Result<Response<T>, ErrorResponse>) -> Void) -> RequestTask {
        let path = URLComponents(string: URLString)?.path ?? URLString
        logger.info("No Api key to execute: \(method) -> \(path)")
        completion(.failure(.empty))
        return requestTask
    }
}
