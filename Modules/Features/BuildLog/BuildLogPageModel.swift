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
import UIKit

extension NSAttributedString: @unchecked @retroactive Sendable {

}

package final class BuildLogPageModel: PageModelType {
    @Published var attributedLogs: NSAttributedString?
    @Published var build: BuildResponseItemModel
    @Published var isFullLogFetched: Bool = false
    let app: V0AppResponseItemModel
    private var log: BuildLogResponseModel?
    @Published var rawLog: String?

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

    var canFetchFullLog: Bool {
        !isFullLogFetched && log?.expiringRawLogUrl != nil
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

    func onFetchFullLog() {
        guard !isLoading, canFetchFullLog else { return }
        guard let rawLogString = log?.expiringRawLogUrl else { return }
        guard let rawLogURL = URL(string: rawLogString) else { return }
        Task {
            do {
                let data = try await Task.detached {
                    return try Data(contentsOf: rawLogURL)
                }.value

                if let string = String(data: data, encoding: .utf8) {
                    self.rawLog = string
                    self.attributedLogs = Rainbow.chunkToAttributed(string)
                    isFullLogFetched = true
                }
            } catch {
                onError(error)
            }
            isLoading = false
        }
    }

    func onShareRawLog() {
        guard let rawLog else { return }
        let url = URL(fileURLWithPath: (NSTemporaryDirectory() as NSString).appendingPathComponent("build_\(build.slug).log"))
        do {
            try rawLog.write(to: url, atomically: true, encoding: .utf8)
            let controller = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            controller.popoverPresentationController?.sourceView = UIView()
            UIApplication.shared.rootViewController?.present(controller, animated: true)
        } catch {
            onError(error)
        }
    }
}

extension UIApplication {
    var windowScene: UIWindowScene? {
        connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
    }

    var rootViewController: UIViewController? {
        return windowScene?.windows.first?.rootViewController
    }
}
