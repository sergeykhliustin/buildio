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

final class BuildViewModel: BaseViewModel<BuildResponseItemModel> {
    private var timer: Timer?
    private var builder: AnyCancellable?
    
    deinit {
        logger.debug("")
    }
    
    override class var shouldRefreshOnInit: Bool {
        return false
    }
    
    func update(_ build: BuildResponseItemModel) {
        if self.value != build {
            self.value = build
            if build.status == .running {
                self.scheduleNextUpdate()
            }
        }
    }
    
    func rebuild(completion: @escaping (ErrorResponse?) -> Void) {
        if case .loading = state {
            return
        }
        if let value = self.value, builder == nil {
            self.state = .loading
            
            builder = BuildsAPI()
                .buildTrigger(appSlug: value.repository.slug, buildParams: BuildTriggerParams(build: value))
                .sink(receiveCompletion: { [weak self] result in
                    guard let self = self else { return }
                    if case .failure(let error) = result {
                        self.error = error
                        self.state = .error
                        completion(error)
                    } else {
                        self.state = .value
                        completion(nil)
                    }
                    self.builder = nil
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
    
    override func afterRefresh() {
        super.afterRefresh()
        scheduleNextUpdate()
    }
    
    private func scheduleNextUpdate() {
        timer?.invalidate()
        if value?.status != .running {
            return
        }
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            self.refresh()
        })
    }
}
