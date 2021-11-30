//
//  File.swift
//  
//
//  Created by Sergey Khliustin on 30.11.2021.
//

import Foundation

public protocol PagingResponseModel {
    associatedtype ItemType: Identifiable
    var data: [ItemType] { get set }
    var paging: V0PagingResponseModel { get set }
}
