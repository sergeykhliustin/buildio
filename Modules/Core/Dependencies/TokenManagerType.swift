//
//  TokenManagerType.swift
//  Modules
//
//  Created by Sergii Khliustin on 05.11.2024.
//

import Foundation

package protocol TokenManagerType: AnyObject {
    var token: Token? { get }
    var tokens: [Token] { get }
    func set(_ token: Token)
    func remove(_ token: Token)
}
