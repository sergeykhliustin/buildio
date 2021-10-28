//
//  TokenManager.swift
//  Buildio
//
//  Created by severehed on 24.10.2021.
//

import Foundation
import Combine
import KeychainAccess

struct Token: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.token == rhs.token && lhs.token == rhs.token
    }
    
    let token: String
    let email: String
    var current: Bool
    
    init(token: String, email: String) {
        self.token = token
        self.email = email
        self.current = false
    }
    
    fileprivate init(token: String, email: String, current: Bool) {
        self.token = token
        self.email = email
        self.current = current
    }
}

class TokenManager: ObservableObject {
    private static let keychain = Keychain()
    
    @Published private(set) var tokens: [Token] {
        didSet {
            saveTokens()
        }
    }
    
    @Published var token: Token? = nil {
        willSet {
            if let token = newValue?.token {
                OpenAPIClientAPI.customHeaders = ["Authorization": token]
            } else {
                OpenAPIClientAPI.customHeaders = [:]
            }
        }
        didSet {
            guard let newValue = token else { return }
            
            var tokens = tokens
            if !tokens.contains(newValue) {
                tokens.append(newValue)
            }
            
            self.tokens = tokens.reduce([Token](), { partialResult, token in
                var result = partialResult
                var token = token
                token.current = token.token == newValue.token
                result.append(token)
                return result
            })
        }
    }
    
    static let shared = TokenManager()
    
    private init() {
        self.tokens = TokenManager.getTokens()
        self.token = self.tokens.first(where: { $0.current })
        
        if let currentToken = self.token?.token {
            OpenAPIClientAPI.customHeaders = ["Authorization": currentToken]
        }
    }
    
    private static func getTokens() -> [Token] {
        let keychain = TokenManager.keychain
        return keychain.allKeys().reduce([Token]()) { partialResult, key in
            var result = partialResult
            if let token = keychain[key] {
                let current = keychain[attributes: key]?.label == "current"
                result.append(Token(token: token, email: key, current: current))
            }
            return result
        }
    }
    
    private func saveTokens() {
        let keychain = TokenManager.keychain
        do {
            try keychain.removeAll()
        } catch {
            logger.error(error)
        }
        tokens.forEach { token in
            var keychain = keychain
            if token.current {
                keychain = keychain.label("current")
            }
            do {
               try keychain.set(token.token, key: token.email)
            }
            catch {
                logger.error(error)
            }
        }
    }
    
}

fileprivate extension UserDefaults {
    var tokens: [String] {
        get {
            return self.array(forKey: "tokens") as? [String] ?? []
        }
        set {
            set(newValue, forKey: "tokens")
            synchronize()
        }
    }
    
    var currentToken: String? {
        get {
            return self.string(forKey: "token")
        }
        set {
            set(newValue, forKey: "token")
            synchronize()
        }
    }
}
