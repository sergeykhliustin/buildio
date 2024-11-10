//
//  AbortBuildPageModel.swift
//  Modules
//
//  Created by Sergii Khliustin on 07.11.2024.
//

import Foundation
import UITypes
import Dependencies
import API
import Models

package final class AbortBuildPageModel: PageModelType {
    @Published var reason: String = ""
    @Published var build: BuildResponseItemModel

    package init(dependencies: DependenciesType, build: BuildResponseItemModel) {
        self.build = build
        super.init(dependencies: dependencies)
        subscribeRunningBuild(id: self.id, build: build) { [weak self] build in
            self?.build = build
            if build.status != .running {
                self?.dependencies.navigator.dismiss()
            }
        }
    }

    func onAbort() {
        guard !isLoading else { return }
        isLoading = true
        Task {
            do {
                try await dependencies.apiFactory.api(BuildsAPI.self).abort(build: build, reason: reason)
                dependencies.navigator.dismiss()
            } catch {
                onError(error)
            }
            isLoading = false
        }
    }
}
