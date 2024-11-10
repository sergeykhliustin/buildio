//
//  PageModelType.swift
//  Modules
//
//  Created by Sergii Khliustin on 03.11.2024.
//

import Foundation
import SwiftUI
import Dependencies
import Components
import API
import Models

@MainActor
open class PageModelType: ObservableObject, Identifiable {
    package let dependencies: DependenciesType
    @Published package var isLoading: Bool = false
    @Published package var error: Error?

    package init(dependencies: DependenciesType) {
        self.dependencies = dependencies
    }

    private var errorTimer: Timer?
    package func onError(_ error: Error) {
        guard (error as? CancellationError) == nil else { return }
        let errorMessage = (error as? ErrorResponse)?.rawErrorString ?? error.localizedDescription
        guard !errorMessage.isEmpty && errorMessage != "cancelled" && !errorMessage.contains("CancellationError") else { return }
        let displayDuration = calculateErrorDisplayDuration(for: errorMessage)

        withAnimation(.easeInOut(duration: 0.3)) {
            self.error = error
        }

        Task.detached {
            try await Task.sleep(for: .seconds(displayDuration))
            await MainActor.run {
                withAnimation(.easeInOut(duration: 0.3)) {
                    self.error = nil
                }
            }
        }
    }

    private func calculateErrorDisplayDuration(for message: String) -> TimeInterval {
        // Basic calculation: 1 second per 10 characters with a minimum of 4 seconds and a maximum of 10 seconds
        let baseDuration: TimeInterval = 4
        let durationPerCharacter: TimeInterval = 0.1
        let maxDuration: TimeInterval = 10
        return max(baseDuration, min(TimeInterval(message.count) * durationPerCharacter, maxDuration))
    }

    nonisolated(unsafe) package var tasks: [Task<Void, Never>] = []

    package func subscribeActivities(_ handler: @escaping () -> Void) {
        let task = Task { [dependencies] in
            let stream = await dependencies.activityProvider.subscribe()
            for await _ in stream {
                guard !Task.isCancelled else { break }
                handler()
            }
        }
        self.tasks.append(task)
    }

    package func subscribeRunningBuild(id: ObjectIdentifier, build: BuildResponseItemModel, handler: @escaping (BuildResponseItemModel) -> Void) {
        guard build.status == .running else { return }
        let task = Task { [dependencies] in
            let stream = await dependencies.buildStatusProvider.subscribe(id: id, build: build)
            for await updatedBuild in stream {
                guard !Task.isCancelled else {
                    break
                }
                handler(updatedBuild)
            }
        }
        self.tasks.append(task)
    }

    package nonisolated func unsubscribe() {
        self.tasks.forEach { $0.cancel() }
        self.tasks.removeAll()
    }

    deinit {
        unsubscribe()
    }
}

