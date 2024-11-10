//
//  ArtifactsPageModel.swift
//  Modules
//
//  Created by Sergii Khliustin on 10.11.2024.
//

import Foundation
import UITypes
import Models
import Dependencies
import API

package final class ArtifactsPageModel: PageModelType {
    let build: BuildResponseItemModel
    @Published var response: V0ArtifactListResponseModel?
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
                self.response = try await dependencies.apiFactory
                    .api(BuildArtifactAPI.self)
                    .artifactList(appSlug: build.repository.slug, buildSlug: build.slug)
            } catch {
                onError(error)
            }
            isLoading = false
        }
    }

    var canLoadMore: Bool {
        response?.paging.next != nil
    }

    func loadMore() {
        guard !isLoading else { return }
        isLoading = true
        Task {
            do {
                let next = response?.paging.next
                var data = try await dependencies.apiFactory
                    .api(BuildArtifactAPI.self)
                    .artifactList(appSlug: build.repository.slug, buildSlug: build.slug, next: next)
                data.data = (self.response?.data ?? []) + data.data
                self.response = data
            } catch {
                onError(error)
            }
            isLoading = false
        }
    }
}
