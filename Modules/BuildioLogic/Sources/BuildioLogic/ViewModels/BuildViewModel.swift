//
//  BuildViewModel.swift
//  Buildio
//
//  Created by Sergey Khliustin on 02.11.2021.
//

import Foundation
import Models
import SwiftUI
import Combine
import BitriseAPIs

public struct ModelError: Hashable, Identifiable {
    public var id: Int {
        return hashValue
    }
    public let title: String
    public let message: String
}

public final class BuildViewModel: BaseApiViewModel<BuildResponseItemModel>, CacheableViewModel {
    @Published var updater = false
    
    private var actionCancellable: Task<Void, Never>?
    private var estimatorFetcher: AnyCancellable?
    private var updaterTimer: Timer?
    private var statusTimer: Timer?
    @Published private(set) var estimatedDuration: Double?
    @Published public var actionError: ModelError?
    
    public var progress: Double? {
        if let estimatedDuration = estimatedDuration,
           let duration = value?.duration,
            value?.status == .running {
            return min(duration / estimatedDuration, 0.99)
        }
        return nil
    }
    
    override class var shouldRefreshOnInit: Bool {
        return false
    }
    
    override class var shouldHandleTokenUpdates: Bool {
        return false
    }
    
    override class var shouldHandleActivityUpdates: Bool {
        return true
    }
    
    override class var shouldRefreshAfterBackground: Bool {
        return true
    }
    
    override var shouldHandleActivityUpdate: Bool {
        return value?.status == .running
    }
    
    override var shouldRefreshAfterBackground: Bool {
        return value?.status == .running
    }
    
    init(_ tokenManager: TokenManager, build: BuildResponseItemModel) {
        super.init(tokenManager)
        self.value = build
        startUpdaterTimer()
        startStatusTimer()
        fetchEstimateIfNeeded()
    }
    
    public override func afterRefresh() {
        super.afterRefresh()
        startUpdaterTimer()
        startStatusTimer()
        fetchEstimateIfNeeded()
    }
    
    public func rebuild(completion: ((ErrorResponse?) -> Void)? = nil) {
        if case .loading = state {
            return
        }
        if let value = self.value, actionCancellable == nil {
            self.state = .loading
            actionCancellable =
            Task {
                do {
                    _ = try await apiFactory.api(BuildsAPI.self)
                        .buildTrigger(appSlug: value.repository.slug, buildParams: BuildTriggerParams(build: value))
                    self.state = .value
                    self.refresh()
                } catch {
                    self.actionError = ModelError(title: "Failed to start the Build", message: (error as? ErrorResponse)?.rawErrorString ?? "")
                    self.error = error as? ErrorResponse
                    self.state = .error
                }
                self.actionCancellable = nil
                completion?(self.error)
            }
        }
    }
    
    public func abort(reason: String?, completion: (() -> Void)? = nil) {
        guard let reason = reason else { return }
        if case .loading = state {
            return
        }
        if let value = self.value, actionCancellable == nil {
            self.state = .loading
            let params = V0BuildAbortParams(abortReason: reason, abortWithSuccess: false, skipNotifications: false)
            actionCancellable =
            Task {
                do {
                    _ = try await apiFactory.api(BuildsAPI.self)
                        .buildAbort(appSlug: value.repository.slug, buildSlug: value.slug, buildAbortParams: params)
                    self.state = .value
                    self.refresh()
                } catch {
                    self.actionError = ModelError(title: "Failed to abort the Build", message: (error as? ErrorResponse)?.rawErrorString ?? "")
                    self.error = error as? ErrorResponse
                    self.state = .error
                }
                self.actionCancellable = nil
                completion?()
            }
        }
    }
    
    override func fetch() async throws -> BuildResponseItemModel {
        let appSlug = value?.repository.slug ?? ""
        let buildSlug = value?.slug ?? ""
        var build = try await apiFactory.api(BuildsAPI.self).buildShow(appSlug: appSlug, buildSlug: buildSlug).data
        if let repository = self.value?.repository {
            build.repository = repository
        }
        return build
    }
    
    private func fetchEstimateIfNeeded() {
        guard let value = self.value else { return }
        guard value.status == .running else { return }
        guard let finishedAt = value.environmentPrepareFinishedAt else { return }
        guard estimatedDuration == nil else { return }
        Task {
            do {
                let duration = try await apiFactory
                    .api(BuildsAPI.self)
                    .buildList(appSlug: value.repository.slug,
                               branch: value.branch,
                               workflow: value.triggeredWorkflow,
                               before: finishedAt,
                               status: .success,
                               limit: 1).data.first?.duration
                estimatedDuration = duration
            } catch {
                logger.error(error)
            }
        }
    }
    
    private func startStatusTimer() {
        statusTimer?.invalidate()
        guard case .running = value?.status else { return }
        guard value?.environmentPrepareFinishedAt == nil else { return }
        statusTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            self.refresh()
        })
    }
    
    private func startUpdaterTimer() {
        updaterTimer?.invalidate()
        guard case .running = value?.status else { return }
        updaterTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            self.updater.toggle()
        })
    }
}
