//
//  TokenManager.swift
//  Buildio
//
//  Created by severehed on 24.10.2021.
//

import Foundation
import Combine

class TokenManager: ObservableObject {
    @Published private(set) var tokens: [String] {
        didSet {
            UserDefaults.standard.tokens = tokens
        }
    }
    @Published private(set) var currentToken: String? {
        didSet {
            UserDefaults.standard.currentToken = currentToken
        }
    }
    
    static let shared = TokenManager()
    
    private init() {
        self.tokens = UserDefaults.standard.tokens
        self.currentToken = UserDefaults.standard.currentToken
        if let currentToken = self.currentToken {
            SwaggerClientAPI.customHeaders = ["Authorization": currentToken]
            if self.tokens.isEmpty {
                self.tokens = [currentToken]
            }
        }
    }
    
    func setToken(_ token: String) {
        SwaggerClientAPI.customHeaders = ["Authorization": token]
        if !self.tokens.contains(token) {
            self.tokens.append(token)
        }
        
        self.currentToken = token
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
