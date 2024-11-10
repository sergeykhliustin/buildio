//
//  BuildYmlPageModel.swift
//  Modules
//
//  Created by Sergii Khliustin on 05.11.2024.
//

import Foundation
import UITypes
import API
import Models
import Dependencies

package final class BuildYmlPageModel: PageModelType {
    @Published private(set) var yml: String?
    let build: BuildResponseItemModel

    package init(dependencies: DependenciesType, build: BuildResponseItemModel) {
        self.build = build
        super.init(dependencies: dependencies)
        refresh()
    }

    func refresh() {
        guard !isLoading else { return }
        isLoading = true
        Task {
            do {
                self.yml = try await dependencies.apiFactory.api(BuildsAPI.self).buildBitriseYmlShow(appSlug: build.repository.slug, buildSlug: build.slug)
            } catch {
                onError(error)
            }
            isLoading = false
        }
    }
}

