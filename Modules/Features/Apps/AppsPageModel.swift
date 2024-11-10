import Foundation
import SwiftUI
import Dependencies
import UITypes
import Models
import API
import Logger
import Components

package final class AppsPageModel: PageModelType {
    private let fetchLimit = 50
    private let completion: ((V0AppResponseItemModel) -> Void)?
    @AppStorageCodable(Settings.key) var settings = Settings() {
        willSet {
            guard let email = dependencies.tokenManager.token?.email else { return }
            self.mutedApps = newValue.mutedApps[email] ?? []
        }
    }
    @Published private var mutedApps: [String] = []
    @Published var response: V0AppListResponseModel?
    @Published var query: String = "" {
        didSet {
            refresh()
        }
    }

    deinit {
        logger.debug("AppsPageModel deinit")
    }

    package init(dependencies: DependenciesType, completion: ((V0AppResponseItemModel) -> Void)? = nil) {
        self.completion = completion
        super.init(dependencies: dependencies)
        self.mutedApps = settings.mutedApps[dependencies.tokenManager.token?.email ?? ""] ?? []
        refresh()
    }

    private var refreshTask: Task<Void, Never>?

    func refresh() {
        refreshTask?.cancel()
        isLoading = true
        refreshTask = Task { [query] in
            do {
                let response = try await dependencies.apiFactory
                    .api(ApplicationAPI.self)
                    .appList(title: query, sortBy: nil, limit: fetchLimit)
                if self.query == query && !Task.isCancelled {
                    self.response = response
                }
                self.refreshTask = nil
            } catch {
                onError(error)
            }
            isLoading = false
        }
    }

    var canLoadMore: Bool {
        return response?.paging.next != nil
    }

    func loadMore() {
        guard !isLoading else { return }
        guard let next = response?.paging.next else { return }
        isLoading = true
        Task { [self] in
            do {
                var response = try await dependencies.apiFactory
                    .api(ApplicationAPI.self)
                    .appList(title: query, sortBy: .lastBuildAt, next: next, limit: fetchLimit)
                response.data = (self.response?.data ?? []) + response.data
                self.response = response
            } catch {
                onError(error)
            }
            isLoading = false
        }
    }

    func isMuted(_ app: V0AppResponseItemModel) -> Bool {
        return mutedApps.contains(app.title)
    }

    func toggleMuted(_ app: V0AppResponseItemModel) {
        guard let email = dependencies.tokenManager.token?.email else { return }
        if isMuted(app) {
            mutedApps.removeAll { $0 == app.title }
        } else {
            mutedApps.append(app.title)
        }
        settings.mutedApps[email] = mutedApps
    }

    func onApp(_ app: V0AppResponseItemModel) {
        if let completion = completion {
            completion(app)
            dependencies.navigator.dismiss()
        } else {
            dependencies.navigator.show(.builds(app: app))
        }
    }
}
