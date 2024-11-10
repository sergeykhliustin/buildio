//
//  TokenManager.swift
//  Buildio
//
//  Created by Sergey Khliustin on 24.10.2021.
//

import Foundation
import Combine
import KeychainAccess
import Logger
import Environment
import Dependencies

package final class PreviewTokenManager: TokenManager {
    public override init(_ account: String? = nil) {
        super.init(account)
        self.tokens = [Token.demo()]
        self.token = self.tokens.first
    }
    
    override func saveTokens() {
        
    }
}

package class TokenManager: ObservableObject, TokenManagerType {
    private let keychain: Keychain
    
    @Published package fileprivate(set) var tokens: [Token] {
        didSet {
            saveTokens()
        }
    }
    
    @Published package var token: Token? {
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
    
    package init(_ account: String? = nil) {
        let keychain = Keychain()
        if ProcessInfo.processInfo.isTestEnv {
            self.tokens = []
        } else {
            self.tokens = keychain.allKeys().reduce([Token]()) { partialResult, key in
                var result = partialResult
                if let token = keychain[key] {
                    result.append(Token(token: token, email: key))
                }
                return result
            }
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
    
    package func set(_ token: Token) {
        if let token = tokens.first(where: { $0.token == token.token }) {
            logger.debug("")
            self.token = token
        } else {
            self.token = token
        }
    }
    
    package func remove(_ token: Token) {
        guard let index = tokens.firstIndex(of: token) else { return }
        tokens.remove(at: index)
        if token == self.token {
            self.token = tokens.first
        }
    }
    
    fileprivate func saveTokens() {
        guard !ProcessInfo.processInfo.isTestEnv else { return }

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
}

private extension UserDefaults {
    private static let lastAccountKey = "lastAccount"
    
    var lastAccount: String? {
        get {
            string(forKey: Self.lastAccountKey)
        }
        set {
            set(newValue, forKey: Self.lastAccountKey)
        }
    }
}

