//
//  ActivitiesViewModel.swift
//  Buildio
//
//  Created by Sergey Khliustin on 03.11.2021.
//

import Models
import BitriseAPIs

public final class ActivitiesViewModel: RootPagingViewModel<V0ActivityEventListResponseModel>, RootViewModel {
    private let fetchLimit: Int = 10
    
    deinit {
        logger.debug("")
    }
    
    public override init(_ tokenManager: TokenManager) {
        super.init(tokenManager)
    }
    
    override func fetch() async throws -> V0ActivityEventListResponseModel {
        try await apiFactory.api(ActivityAPI.self).activityList(limit: fetchLimit)
    }
    
    override func fetchPage(next: String?) async throws -> PagingViewModel<V0ActivityEventListResponseModel>.ValueType {
        try await apiFactory.api(ActivityAPI.self).activityList(next: next, limit: fetchLimit)
    }
    
    public func findBuild(_ item: V0ActivityEventResponseItemModel) async -> BuildResponseItemModel? {
        let targetComponents = item.targetPathString?.split(separator: "/")
        guard state != .loading,
              item.eventStype == "build",
              let components = targetComponents,
              components.count == 2,
              components.first == "build",
              let appName = item.description?.components(separatedBy: " - ").first,
              !appName.isEmpty else { return nil }
        let state = self.state
        self.state = .loading
        defer {
            self.state = state
        }
        let buildSlug = components[1]
        guard let app = try? await apiFactory.api(ApplicationAPI.self).appList(title: appName).data.first(where: { $0.title == appName }) else {
            return nil
        }
        var build = try? await apiFactory.api(BuildsAPI.self).buildShow(appSlug: app.slug, buildSlug: String(buildSlug)).data
        build?.repository = app
        return build
    }
}
