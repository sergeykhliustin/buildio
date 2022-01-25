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
    
    private var fetcher: AnyCancellable?
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
        fetcher = ActivityAPI(apiToken: self.token)
            .activityList(limit: 1)
            .map({ $0.data.first?.createdAt })
            .sink(receiveCompletion: { [weak self] _ in
                self?.scheduleNextUpdate()
            }, receiveValue: { [weak self] date in
                if let date = date {
                    self?.lastActivityDate = date
                }
            })
    }
    
    private func scheduleNextUpdate() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            self.refresh()
        })
    }
}
