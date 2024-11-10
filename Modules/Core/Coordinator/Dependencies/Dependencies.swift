//
//  Dependencies.swift
//  Modules
//
//  Created by Sergii Khliustin on 03.11.2024.
//
import Foundation
import Dependencies

final class Dependencies: DependenciesType {
    let tokenManager: TokenManagerType
    let apiFactory: ApiFactory
    let navigator: NavigatorType
    let activityProvider: ActivityProviderType
    let buildStatusProvider: BuildStatusProviderType

    init(
        tokenManager: TokenManager,
        navigator: NavigatorType,
        activityProvider: ActivityProviderType,
        buildStatusProvider: BuildStatusProviderType
    ) {
        let token = tokenManager.token?.token
        self.tokenManager = tokenManager
        self.apiFactory = ApiFactory(token: token)
        self.navigator = navigator
        self.activityProvider = activityProvider
        self.buildStatusProvider = buildStatusProvider
    }
}
