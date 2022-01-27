//
//  ActivityWatcher.swift
//  
//
//  Created by Sergey Khliustin on 06.12.2021.
//

import Foundation
import Combine
import BitriseAPIs

final class ActivityWatcher: ObservableObject {
    static let lastActivityDateUpdated: Notification.Name = Notification.Name(rawValue: "ActivityWatcher.lastActivityDateUpdated")
    
    private var fetcher: Task<Void, Never>?
    private var timer: Timer?
    private var tokenHandler: AnyCancellable?
    private var token: String?
    private var lastActivityDate: Date = Date() {
        didSet {
            NotificationCenter.default.post(name: Self.lastActivityDateUpdated, object: lastActivityDate)
        }
    }
    
    init(_ tokenManager: TokenManager) {
        tokenHandler = tokenManager.$token.sink(receiveValue: { [weak self] token in
            guard let self = self else { return }
            if let token = token, !token.isDemo {
                self.token = token.token
                self.refresh()
            } else {
                self.timer?.invalidate()
            }
        })
    }
    
    private func refresh() {
        fetcher?.cancel()
        fetcher = Task {
            do {
                if let date = try await ActivityAPI(apiToken: self.token).activityList(limit: 1).data.first?.createdAt {
                    self.lastActivityDate = date
                }
            } catch {
                logger.error(error)
            }
            scheduleNextUpdate()
        }
    }
    
    private func scheduleNextUpdate() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.timer?.invalidate()
            self.timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { [weak self] timer in
                guard let self = self else {
                    timer.invalidate()
                    return
                }
                self.refresh()
            })
        }
    }
}
