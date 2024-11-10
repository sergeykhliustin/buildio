//
//  BuildsAPI+abort.swift
//  Modules
//
//  Created by Sergii Khliustin on 07.11.2024.
//

import Models

package extension BuildsAPI {
    @discardableResult
    func abort(build: BuildResponseItemModel, reason: String) async throws -> V0BuildAbortResponseModel {
        return try await buildAbort(
            appSlug: build.repository.slug,
            buildSlug: build.slug,
            buildAbortParams: V0BuildAbortParams(
                abortReason: reason,
                abortWithSuccess: false,
                skipNotifications: true
            )
        )
    }

    @discardableResult
    func rebuild(build: BuildResponseItemModel) async throws -> V0BuildTriggerRespModel {
        return try await buildTrigger(
            appSlug: build.repository.slug,
            buildParams: BuildTriggerParams(build: build)
        )
    }
}
