import Foundation
import Models
import API
import AsyncAlgorithms
import Logger
import Dependencies

package actor ActivityProvider: ActivityProviderType {
    private let token: String?
    private var lastActivityDate: Date? {
        didSet {
            guard let date = lastActivityDate else { return }
            for consumer in consumers.values {
                consumer.yield(date)
            }
        }
    }

    private var task: Task<Void, Never>?
    private var consumers: [UUID: AsyncStream<Date>.Continuation] = [:]

    package init(token: String?) {
        self.token = token
    }

    deinit {
        logger.debug("ActivityProvider deinitialized")
    }

    package func subscribe() async -> AsyncStream<Date> {
        if consumers.isEmpty {
            startPolling()
        }
        return AsyncStream { continuation in
            let id = UUID()
            consumers[id] = continuation
            continuation.onTermination = { @Sendable [weak self] _ in
                Task {
                    await self?.removeConsumer(id)
                }
            }
        }
    }

    private func removeConsumer(_ id: UUID) {
        consumers.removeValue(forKey: id)
        if consumers.isEmpty {
            stopPolling()
        }
    }

    private func startPolling() {
        guard let token else { return }
        logger.debug("Starting activity polling")
        task = Task {
            await startPooling(interval: 2.0) { [self] in
                do {
                    guard let date = try await ActivityAPI(apiToken: token)
                        .activityList(limit: 1).data.first?.createdAt
                    else { return }
                    if lastActivityDate != date {
                        lastActivityDate = date
                    }
                } catch {
                    if !Task.isCancelled {
                        logger.error("Failed to fetch activity: \(error)")
                    }
                }
            }
        }
    }

    private func stopPolling() {
        logger.debug("Stopping activity polling")
        task?.cancel()
        task = nil
    }

    private func startPooling(interval: TimeInterval, action: @escaping () async -> Void) async {
        let timer = AsyncTimerSequence(interval: .seconds(interval), clock: .suspending)
        for await _ in timer {
            guard !Task.isCancelled else { return }
            await action()
        }
    }
}
