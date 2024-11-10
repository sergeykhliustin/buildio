//
//  Token.swift
//  Modules
//
//  Created by Sergii Khliustin on 03.11.2024.
//

package struct Token: Equatable, Identifiable, Hashable, Sendable {
    package var id: String {
        token
    }
    
    package static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.token == rhs.token && lhs.token == rhs.token
    }
    
    package let token: String
    package let email: String
    package var isDemo: Bool {
        token == "demo"
    }

    package init(token: String, email: String) {
        self.token = token
        self.email = email
    }
    
    package static func demo() -> Token {
        return Token(token: "demo", email: "demo@example.com")
    }
}
