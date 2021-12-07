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
    @Published var lastActivityDate: Date = Date()
    static let shared = ActivityWatcher()
    
    private var fetcher: AnyCancellable?
    private var timer: Timer?
    
    private init() {
        refresh()
    }
    
    private func refresh() {
        fetcher = ActivityAPI()
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
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            self.refresh()
        })
    }
}
