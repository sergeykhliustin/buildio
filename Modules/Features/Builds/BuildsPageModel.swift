//
//  BuildsViewModel.swift
//  Buildio
//
//  Created by Sergey Khliustin on 01.10.2021.
//

import Foundation
import Models
import Combine
import API
import UITypes
import Logger
import Dependencies

package final class BuildsPageModel: PageModelType {
    @Published var data: V0BuildListResponseModel?
    @Published var loadingBuildId: String?
    private let fetchLimit: Int = 30
    private(set) var app: V0AppResponseItemModel?

    deinit {
        logger.debug("")
    }
    
    package init(dependencies: DependenciesType, app: V0AppResponseItemModel?) {
        self.app = app
        super.init(dependencies: dependencies)
        refresh()
        self.subscribeActivities { [weak self] in
            self?.refresh()
        }
    }

    func refresh() {
        guard !isLoading else { return }
        isLoading = true
        Task {
            do {
                let api = dependencies.apiFactory.api(BuildsAPI.self)
                if let app {
                    let data = try await api
                        .buildList(appSlug: app.slug, sortBy: .runningFirst, limit: fetchLimit)
                    self.data = enrich(data, app: app)
                } else {
                    self.data = try await api.buildListAll(limit: fetchLimit)
                }
            } catch {
                self.onError(error)
            }
            self.isLoading = false

            for build in self.data?.data ?? [] {
                guard build.status == .running else { continue }
                self.subscribeRunningBuild(id: self.id, build: build) { [weak self] build in
                    guard let self else { return }
                    guard var data = self.data?.data else { return }
                    if let index = data.firstIndex(where: { $0.slug == build.slug && $0.repository.slug == build.repository.slug }) {
                        data[index] = build
                        self.data?.data = data
                    }
                }
            }
        }
    }

    var canLoadMore: Bool {
        data?.paging.next != nil
    }

    func loadMore() {
        guard !isLoading, let next = data?.paging.next else { return }
        isLoading = true
        Task {
            do {
                let api = dependencies.apiFactory.api(BuildsAPI.self)
                if let app = app {
                    var data = try await api
                        .buildList(appSlug: app.slug, sortBy: .runningFirst, next: next, limit: fetchLimit)
                    data = enrich(data, app: app)
                    data.data = (self.data?.data ?? []) + data.data
                    self.data = data
                } else {
                    var data = try await api.buildListAll(next: next, limit: fetchLimit)
                    data.data = (self.data?.data ?? []) + data.data
                    self.data = data
                }
            } catch {
                onError(error)
            }
            isLoading = false
        }
    }
    
    private func enrich(_ model: V0BuildListResponseModel, app: V0AppResponseItemModel) -> V0BuildListResponseModel {
        var model = model
        let data = model.data.reduce([BuildResponseItemModel]()) { partialResult, item in
            var partialResult = partialResult
            var item = item
            item.repository = app
            partialResult.append(item)
            return partialResult
        }
        model.data = data
        return model
    }

    func onBuild(_ build: BuildResponseItemModel) {
        dependencies.navigator.show(.build(build))
    }

    func onRebuild(_ build: BuildResponseItemModel) {
        loadingBuildId = build.slug
        Task {
            do {
                try await dependencies.apiFactory.api(BuildsAPI.self).rebuild(build: build)
            } catch {
                onError(error)
            }
            loadingBuildId = nil
        }
    }
}
