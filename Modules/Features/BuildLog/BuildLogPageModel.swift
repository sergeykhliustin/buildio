//
//  BuildLogPageModel.swift
//  Modules
//
//  Created by Sergii Khliustin on 06.11.2024.
//

import Foundation
import UITypes
import Dependencies
import API
import Models
import Rainbow

extension NSAttributedString: @unchecked @retroactive Sendable {

}

package final class BuildLogPageModel: PageModelType {
    @Published var attributedLogs: NSAttributedString?
    @Published var build: BuildResponseItemModel
    let app: V0AppResponseItemModel
    private var log: BuildLogResponseModel?

    package init(dependencies: DependenciesType, build: BuildResponseItemModel) {
        self.build = build
        self.app = build.repository
        super.init(dependencies: dependencies)
        refresh()
        subscribeRunningBuild(id: id, build: build) { [weak self] build in
            self?.build = build
            self?.refresh()
        }
    }

    private var refreshTask: Task<Void, Never>?
    deinit {
        refreshTask?.cancel()
        refreshTask = nil
    }

    private func refresh(withBuild: Bool = false) {
        refreshTask?.cancel()
        isLoading = true
        refreshTask = Task {
            defer {
                if !Task.isCancelled {
                    isLoading = false
                }
            }
            do {
                let log = try await dependencies.apiFactory
                    .api(BuildsAPI.self)
                    .buildLog(appSlug: app.slug, buildSlug: build.slug, timestamp: self.log?.nextAfterTimestamp)
                guard !Task.isCancelled else { return }
                if let logs = await parseLog(log) {
                    guard !Task.isCancelled else { return }
                    attributedLogs = logs
                }
                self.log = log
            } catch {
                onError(error)
            }
        }
    }

    private func parseLog(_ log: BuildLogResponseModel) async -> NSAttributedString? {
        await Task.detached { [attributedLogs] in
            var result: NSAttributedString?
            let logChunks = log.logChunks
            let raw = logChunks.map({ $0.chunk }).joined()
            let attributed = logChunks.reduce(NSMutableAttributedString()) { partialResult, chunk in
                partialResult.append(Rainbow.chunkToAttributed(chunk.chunk))
                return partialResult
            }

            if attributed.length > 0 {
                if let prevLogs = attributedLogs {
                    let mutable = NSMutableAttributedString(attributedString: prevLogs)
                    mutable.append(attributed)
                    result = mutable
                } else {
                    result = attributed
                }
            }
            return result
        }.value
    }
}
