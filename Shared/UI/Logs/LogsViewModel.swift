//
//  LogsViewModel.swift
//  Buildio
//
//  Created by severehed on 01.11.2021.
//

import Foundation
import Models
import Combine

class LogsViewModel: BaseViewModel<BuildLogResponseModel> {
    let build: V0BuildResponseItemModel
    private var timer: Timer?
    
    init(build: V0BuildResponseItemModel) {
        self.build = build
        super.init()
        
        if build.status == .running {
            timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { [weak self] timer in
                guard let self = self else {
                    timer.invalidate()
                    return
                }
                self.refresh()
            })
        }
    }
    
    override func fetch() -> AnyPublisher<BuildLogResponseModel, ErrorResponse> {
        BuildsAPI().buildLog(appSlug: build.repository.slug, buildSlug: build.slug)
            .eraseToAnyPublisher()
    }
}
