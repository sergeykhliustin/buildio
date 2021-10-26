//
//  URLSessionRequestBuilder.swift
//  Buildio
//
//  Created by severehed on 04.10.2021.
//

import Foundation
import Models

public class URLSessionRequestBuilder<T>: RequestBuilder<T> {
    
    public override func execute(_ completion: @escaping (Response<T>?, Error?) -> Void) {
//        let request = URLRequest(url: URL(string: URLString))
    }
    
}
