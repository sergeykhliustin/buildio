//
//  TokenManager.swift
//  Buildio
//
//  Created by Sergey Khliustin on 24.10.2021.
//

import Foundation
import Combine
import KeychainAccess

public struct Token: Equatable, Identifiable {
    public var id: String {
        token
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.token == rhs.token && lhs.token == rhs.token
    }
    
    let token: String
    public let email: String
    public var isDemo: Bool = false
    
    public init(token: String, email: String) {
        self.token = token
        self.email = email
    }
    
    static func demo() -> Token {
        var token = Token(token: "demo", email: "demo@example.com")
        token.isDemo = true
        return token
    }
}

public final class PreviewTokenManager: TokenManager {
    public override init(_ account: String? = nil) {
        super.init(account)
        self.tokens = [Token.demo()]
        self.token = self.tokens.first
    }
    
    override func saveTokens() {
        
    }
}

public class TokenManager: ObservableObject {
    private let keychain: Keychain
    
    @Published public fileprivate(set) var tokens: [Token] {
        didSet {
            saveTokens()
        }
    }
    
    @Published public var token: Token? {
        didSet {
            guard let newValue = token else {
                UserDefaults.standard.lastAccount = nil
                return
            }
            
            var tokens = tokens
            if !tokens.contains(newValue) {
                tokens.append(newValue)
            }
            self.tokens = tokens
            UserDefaults.standard.lastAccount = newValue.email
        }
    }
    
    public init(_ account: String? = nil) {
        let keychain = Keychain()
        self.tokens = keychain.allKeys().reduce([Token]()) { partialResult, key in
            var result = partialResult
            if let token = keychain[key] {
                result.append(Token(token: token, email: key))
            }
            return result
        }
        self.keychain = keychain
        if let account = account {
            self.token = self.tokens.first(where: { $0.email == account })
        }
        if self.token == nil, let lastUsed = UserDefaults.standard.lastAccount {
            self.token = self.tokens.first(where: { $0.email == lastUsed })
        }
        if self.token == nil {
            self.token = self.tokens.first
        }
    }
    
    public func selectAccount(_ account: String) {
        if let token = tokens.first(where: { $0.email == account }) {
            logger.debug("")
            self.token = token
        }
    }
    
    public func remove(_ token: Token) {
        guard let index = tokens.firstIndex(of: token) else { return }
        tokens.remove(at: index)
        if token == self.token {
            self.token = tokens.first
        }
    }
    
    fileprivate func saveTokens() {
        do {
            try keychain.removeAll()
        } catch {
            logger.error(error)
        }
        tokens
            .filter({ !$0.isDemo })
            .forEach { token in
                do {
                    try keychain.set(token.token, key: token.email)
                } catch {
                    logger.error(error)
                }
            }
    }
    
    public func setupDemo() {
        self.token = Token.demo()
    }
    
    public func exitDemo() {
        guard let token = self.token, token.isDemo else { return }
        remove(token)
    }
}
