//
//  LogsViewModel.swift
//  Buildio
//
//  Created by Sergey Khliustin on 01.11.2021.
//

import Foundation
import Models
import Combine
import Rainbow
import SwiftUI
import BitriseAPIs

final class LogsViewModel: BaseApiViewModel<BuildLogResponseModel> {
    let build: BuildResponseItemModel
    private var timer: Timer?
    @Published var attributedLogs: NSAttributedString?
    
    deinit {
        logger.debug("")
    }
    
    init(_ tokenManager: TokenManager, build: BuildResponseItemModel) {
        self.build = build
        super.init(tokenManager)
    }
    
    override class var shouldRefreshOnInit: Bool {
        return true
    }
    
    override func fetch() async throws -> BuildLogResponseModel {
        try await apiFactory.api(BuildsAPI.self).buildLog(appSlug: build.repository.slug, buildSlug: build.slug, timestamp: value?.nextAfterTimestamp)
    }
    
    override func afterRefresh() {
        guard let value = value else { return }
        let logChunks = value.logChunks
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let attributed = logChunks.reduce(NSMutableAttributedString()) { partialResult, chunk in
                partialResult.append(Rainbow.chunkToAttributed(chunk.chunk))
                return partialResult
            }
            DispatchQueue.main.sync {
                if attributed.length > 0 {
                    if let prevLogs = self.attributedLogs {
                        let mutable = NSMutableAttributedString(attributedString: prevLogs)
                        mutable.append(attributed)
                        self.attributedLogs = mutable
                    } else {
                        self.attributedLogs = attributed
                    }
                }
                if !value.isArchived {
                    self.scheduleNextUpdate()
                } else {
                    self.timer?.invalidate()
                    self.timer = nil
                }
            }
        }
    }
    
    private func scheduleNextUpdate() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            self.refresh()
        })
    }
}
