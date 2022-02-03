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

public final class LogsViewModel: BaseApiViewModel<BuildLogResponseModel> {
    let build: BuildResponseItemModel
    private var timer: Timer?
    @Published public var attributedLogs: NSAttributedString?
    @Published private var isRawFetched: Bool = false
    public var canFetchRaw: Bool {
        !isRawFetched && value?.expiringRawLogUrl != nil
    }
    
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
    
    public func fetchRaw() {
        guard let value = value, state != .loading,
                let rawLogString = value.expiringRawLogUrl,
                let rawLogUrl = URL(string: rawLogString) else { return }
        state = .loading
        DispatchQueue.global().async { [weak self] in
            do {
                let data = try Data(contentsOf: rawLogUrl)
                var attributed: NSAttributedString?
                if let string = String(data: data, encoding: .utf8) {
                    attributed = Rainbow.chunkToAttributed(string)
                    
                }
                DispatchQueue.main.async {
                    self?.state = .value
                    if let attributed = attributed {
                        self?.attributedLogs = attributed
                        self?.isRawFetched = true
                    }
                }
                
            } catch {
                logger.error(error)
                DispatchQueue.main.async {
                    self?.state = .error
                }
            }
        }
    }
    
    public override func afterRefresh() {
        guard let value = value else { return }
        logger.verbose(value.isArchived)
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
