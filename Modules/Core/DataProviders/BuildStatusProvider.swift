import Foundation
import Models
import API
import AsyncAlgorithms
import Logger
import Dependencies

private extension BuildResponseItemModel {
    var fullId: String {
        "\(repository.slug)/\(slug)"
    }
}

package actor BuildStatusProvider: BuildStatusProviderType {
    private let token: String?

    private nonisolated(unsafe) var task: Task<Void, Never>?
    private var consumers: [String: [ObjectIdentifier: AsyncStream<BuildResponseItemModel>.Continuation]] = [:]
    private var originalBuilds: [String: BuildResponseItemModel] = [:]

    package init(token: String?) {
        self.token = token
    }

    deinit {
        logger.debug("BuildStatusProvider deinitialized")
        stopPolling()
    }

    package func subscribe(id: ObjectIdentifier, build: BuildResponseItemModel) async -> AsyncStream<BuildResponseItemModel> {
        if consumers.isEmpty {
            startPolling()
        }
        let fullId = build.fullId
        originalBuilds[fullId] = build
        return AsyncStream { continuation in
            var buildConsumers = consumers[fullId, default: [:]]
            buildConsumers[id] = continuation
            consumers[fullId] = buildConsumers
            continuation.onTermination = { @Sendable [weak self] _ in
                Task {
                    await self?.removeConsumer(buildId: fullId, id: id)
                }
            }
        }
    }

    private func removeConsumer(buildId: String, id: ObjectIdentifier?) {
        guard var consumers = consumers[buildId] else { return }
        if let id {
            if consumers.count == 1 {
                self.consumers.removeValue(forKey: buildId)
            } else {
                consumers.removeValue(forKey: id)
                self.consumers[buildId] = consumers
            }
        } else {
            self.consumers.removeValue(forKey: buildId)
        }
        if self.consumers.isEmpty {
            stopPolling()
        }
    }

    private func startPolling() {
        guard let token else { return }
        logger.debug("Starting activity polling")
        if task != nil {
            logger.warning("Activity polling already started")
        }
        task = Task { [weak self] in
            guard let self else { return }
            await self.startPooling(interval: 2.0) {
                await withTaskGroup(of: (String, BuildResponseItemModel?).self) { group in
                    for fullId in await self.consumers.keys {
                        let originalBuild = await self.originalBuilds[fullId]
                        let components = fullId.components(separatedBy: "/")
                        guard let appSlug = components.first else { continue }
                        guard let buildSlug = components.last else { continue }
                        group.addTask {
                            guard var build = try? await BuildsAPI(apiToken: token).buildShow(appSlug: appSlug, buildSlug: buildSlug).data
                            else { return (fullId, nil) }
                            if let originalBuild {
                                build.repository = originalBuild.repository
                                if let estimatedDuration = originalBuild.estimatedDuration {
                                    build.estimatedDuration = estimatedDuration
                                } else {
                                    build.estimatedDuration = await self.fetchEstimate(build)
                                }

                            }
                            return (fullId, build)
                        }
                    }

                    for await (fullId, build) in group {
                        guard !Task.isCancelled else { return }
                        guard var build else { continue }
                        guard let buildConsumers = await self.consumers[fullId] else { continue }
                        guard let originalBuild = await self.originalBuilds[fullId] else { continue }
                        build.repository = originalBuild.repository
                        await self.updateEstimatedDuration(fullId, estimatedDuration: build.estimatedDuration)
                        for consumer in buildConsumers.values {
                            consumer.yield(build)
                        }
                        if build.status != .running {
                            await self.removeConsumer(buildId: fullId, id: nil)
                        }
                    }
                }
            }
        }
    }

    private func updateEstimatedDuration(_ fullId: String, estimatedDuration: TimeInterval?) async {
        self.originalBuilds[fullId]?.estimatedDuration = estimatedDuration
    }

    private func fetchEstimate(_ build: BuildResponseItemModel) async -> TimeInterval? {
        guard let token else { return nil }
        guard let finishedAt = build.environmentPrepareFinishedAt else { return nil }
        let api = BuildsAPI(apiToken: token)
        do {
            let duration = try await api
                .buildList(appSlug: build.repository.slug,
                           branch: build.branch,
                           workflow: build.triggeredWorkflow,
                           before: finishedAt,
                           status: .success,
                           limit: 1).data.first?.duration
            return duration
        } catch {
            logger.error("Failed to fetch build estimate: \(error)")
        }
        return nil
    }

    private nonisolated func stopPolling() {
        logger.debug("Stopping activity polling")
        task?.cancel()
        task = nil
    }

    private func startPooling(interval: TimeInterval, action: @escaping () async -> Void) async {
        await action()

        while true {
            do {
                try await Task.sleep(for: .seconds(interval))
                await action()
            } catch {
                break
            }
        }
    }
}
