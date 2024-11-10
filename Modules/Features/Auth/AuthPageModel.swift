//
//  File.swift
//  
//
//  Created by Sergey Khliustin on 06.12.2021.
//

import Models
import Combine
import API
import UITypes
import Dependencies

package final class AuthPageModel: PageModelType {
    @Published var token: String = ""
    let canDemo: Bool

    package init(
        dependencies: DependenciesType,
        canDemo: Bool = false
    ) {
        self.canDemo = canDemo
        super.init(dependencies: dependencies)
    }

    func onDemo() {
        token = Token.demo().token
        validate()
    }

    func validate() {
        let token = token.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !token.isEmpty else {
            return
        }
        isLoading = true
        Task {
            do {
                let profile = try await UserAPI(apiToken: token).userProfile().data
                let token = Token(token: token, email: profile.email)
                dependencies.tokenManager.set(token)
            } catch {
                onError(error)
            }
            isLoading = false
        }
    }
}
