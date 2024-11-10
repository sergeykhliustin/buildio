//
//  AccountsPageModel.swift
//  Modules
//
//  Created by Sergii Khliustin on 05.11.2024.
//

import Foundation
import Dependencies
import UITypes
import API
import Models
import Logger

package final class AccountsPageModel: PageModelType {
    @Published private(set) var tokens: [Token] = []
    @Published private(set) var token: Token?
    @Published private(set) var profiles: [Token: V0UserProfileDataModel] = [:]
    package override init(dependencies: DependenciesType) {
        super.init(dependencies: dependencies)
        self.tokens = dependencies.tokenManager.tokens
        self.token = dependencies.tokenManager.token
        refresh()
    }

    deinit {
        logger.debug("Deinit \(self)")
    }

    func refresh() {
        guard !isLoading else { return }
        isLoading = true
        Task {
            let result = await withTaskGroup(of: (Token, V0UserProfileDataModel?).self) { group in
                for token in tokens {
                    group.addTask {
                        return (token, try? await UserAPI(apiToken: token.token).userProfile().data)
                    }
                }
                var profiles: [Token: V0UserProfileDataModel] = [:]
                for await (token, profile) in group {
                    profiles[token] = profile
                }
                return profiles
            }
            profiles = result
            isLoading = false
        }
    }

    func onSelect(_ token: Token) {
        dependencies.tokenManager.set(token)
    }

    func onRemove(_ token: Token) {
        dependencies.tokenManager.remove(token)
    }
}
