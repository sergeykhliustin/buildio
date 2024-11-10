//
//  DependenciesMock.swift
//  Modules
//
//  Created by Sergii Khliustin on 03.11.2024.
//

package final class DependenciesMock: DependenciesType {
    package let apiFactory: ApiFactory = ApiFactory(token: "demo")
    package let navigator: NavigatorType = NavigatorMock()
    package let activityProvider: ActivityProviderType = ActivityProviderMock()
    package let tokenManager: TokenManagerType = TokenManagerMock()
    package let buildStatusProvider: BuildStatusProviderType = BuildStatusProviderMock()
    package init() {}
}
