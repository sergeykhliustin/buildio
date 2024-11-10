//
//  TokenManagerMock.swift
//  Modules
//
//  Created by Sergii Khliustin on 05.11.2024.
//

import Foundation

package final class TokenManagerMock: TokenManagerType {
    package init() {}
    package var token: Token? { return nil }
    package var tokens: [Token] { return [] }
    package func set(_ token: Token) {}
    package func remove(_ token: Token) {}
}
