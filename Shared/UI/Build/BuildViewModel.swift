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

final class BuildViewModel: BaseViewModel<V0BuildResponseItemModel> {
    private var timer: Timer?
    
    override class var shouldRefreshOnInit: Bool {
        return false
    }
    
    init(build: V0BuildResponseItemModel) {
        super.init()
        self.value = build
        if build.status == .running {
            self.scheduleNextUpdate()
        }
    }
    
    override func fetch() -> AnyPublisher<V0BuildResponseItemModel, ErrorResponse> {
        BuildsAPI().buildShow(appSlug: value!.repository.slug, buildSlug: value!.slug)
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
