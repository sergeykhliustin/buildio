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

struct ModelError: Hashable, Identifiable {
    var id: Int {
        return hashValue
    }
    let title: String
    let message: String
}

final class BuildViewModel: BaseViewModel<BuildResponseItemModel>, CacheableViewModel {
    @Published var updater = false
    
    private var actionCancellable: AnyCancellable?
    private var estimatorFetcher: AnyCancellable?
    private var updaterTimer: Timer?
    private var statusTimer: Timer?
    @Published private(set) var estimatedDuration: Double?
    @Published var actionError: ModelError?
    
    var progress: Double? {
        if let estimatedDuration = estimatedDuration,
           let duration = value?.duration,
            value?.status == .running {
            return min(duration / estimatedDuration, 0.99)
        }
        return nil
    }
    
    deinit {
        logger.debug("")
    }
    
    override class var shouldRefreshOnInit: Bool {
        return false
    }
    
    override class var shouldHandleTokenUpdates: Bool {
        return false
    }
    
    override class var shouldAutoUpdate: Bool {
        return true
    }
    
    init(build: BuildResponseItemModel) {
        super.init()
        self.value = build
        startUpdaterTimer()
        startStatusTimer()
        fetchEstimateIfNeeded()
    }
    
    override func afterRefresh() {
        super.afterRefresh()
        startUpdaterTimer()
        startStatusTimer()
        fetchEstimateIfNeeded()
    }
    
    func rebuild(completion: ((ErrorResponse?) -> Void)? = nil) {
        if case .loading = state {
            return
        }
        if let value = self.value, actionCancellable == nil {
            self.state = .loading
            
            actionCancellable = BuildsAPI()
                .buildTrigger(appSlug: value.repository.slug, buildParams: BuildTriggerParams(build: value))
                .sink(receiveCompletion: { [weak self] result in
                    guard let self = self else { return }
                    if case .failure(let error) = result {
                        self.actionError = ModelError(title: "Failed to start the Build", message: error.rawErrorString)
                        self.error = error
                        self.state = .error
                        completion?(error)
                    } else {
                        self.state = .value
                        self.refresh()
                        completion?(nil)
                    }
                    self.actionCancellable = nil
                }, receiveValue: { value in
                    logger.debug(value)
                })
        }
    }
    
    func abort(reason: String?, completion: (() -> Void)? = nil) {
        guard let reason = reason else { return }
        if case .loading = state {
            return
        }
        if let value = self.value, actionCancellable == nil {
            self.state = .loading
            
            actionCancellable = BuildsAPI()
                .buildAbort(appSlug: value.repository.slug,
                            buildSlug: value.slug,
                            buildAbortParams: V0BuildAbortParams(abortReason: reason, abortWithSuccess: false, skipNotifications: false))
                .sink(receiveCompletion: { [weak self] result in
                    guard let self = self else { return }
                    if case .failure(let error) = result {
                        self.actionError = ModelError(title: "Failed to abort the Build", message: error.rawErrorString)
                        self.error = error
                        self.state = .error
                        completion?()
                    } else {
                        self.state = .value
                        self.refresh()
                        completion?()
                    }
                    self.actionCancellable = nil
                }, receiveValue: { value in
                    logger.debug(value)
                })
        }
    }
    
    override func fetch(params: Any?) -> AnyPublisher<BuildResponseItemModel, ErrorResponse> {
        let appSlug = value?.repository.slug ?? ""
        var buildSlug = value?.slug ?? ""
        if let params = params as? V0BuildTriggerRespModel, let slug = params.slug {
            buildSlug = slug
        }
        return BuildsAPI().buildShow(appSlug: appSlug, buildSlug: buildSlug)
            .map({
                if let repository = self.value?.repository {
                    var build = $0.data
                    build.repository = repository
                    return build
                }
                return $0.data
            })
            .eraseToAnyPublisher()
    }
    
    private func fetchEstimateIfNeeded() {
        guard let value = self.value else { return }
        guard value.status == .running else { return }
        guard let finishedAt = value.environmentPrepareFinishedAt else { return }
        guard estimatedDuration == nil else { return }
        BuildsAPI()
            .buildList(appSlug: value.repository.slug,
                       branch: value.branch,
                       workflow: value.triggeredWorkflow,
                       before: finishedAt,
                       status: .success,
                       limit: 1)
            .replaceError(with: .empty())
            .map({ $0.data.first?.duration })
            .assign(to: &$estimatedDuration)
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
