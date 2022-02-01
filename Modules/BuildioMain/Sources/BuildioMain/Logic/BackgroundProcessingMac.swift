//
//  File.swift
//  
//
//  Created by Sergey Khliustin on 29.11.2021.
//

import BackgroundTasks
import BitriseAPIs
import Combine
import UIKit
import Models

private struct ActivityNotification {
    let email: String
    let title: String
    let date: Date
    
    var time: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        return formatter.string(from: date)
    }
    
    init?(_ item: V0ActivityEventResponseItemModel, email: String) {
        guard let title = item.description else { return nil }
        guard item.createdAt.timeIntervalSince1970 > UserDefaults.standard.lastActivityDate(email: email) else { return nil }
        self.title = title
        self.email = email
        self.date = item.createdAt
    }
}

public final class BackgroundProcessingMac {
    public static let shared = BackgroundProcessingMac()
    
    private init() {
        self.poolingInterval = UserDefaults.standard.pollingInterval
    }
    
    private var fetcher: AnyCancellable?
    private var notificationCenterPubliser: AnyCancellable?
    private var timer: Timer?
    var poolingInterval: TimeInterval
    
    public func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true, block: { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            self.update()
        })
    }
    
    func update() {
        logger.info("")
        self.fetcher?.cancel()
        self.fetcher = Publishers.MergeMany(TokenManager().tokens
                                                .filter({ !$0.isDemo })
                                                .map({ self.activityList($0) }))
            .collect()
            .reduce([ActivityNotification](), { result, values in
                var result = result
                values.forEach({ value in
                    let email = value.0
                    result.append(contentsOf: value.1.compactMap({ ActivityNotification($0, email: email) }))
                })
                return result
            })
            .eraseToAnyPublisher()
            .sink { [weak self] _ in
                self?.fetcher = nil
            } receiveValue: { result in
                DispatchQueue.main.async {
                    result.forEach { activity in
                        if activity.date.timeIntervalSince1970 > UserDefaults.standard.lastActivityDate(email: activity.email) {
                            UserDefaults.standard.setLastActivityDate(activity.date.timeIntervalSince1970, email: activity.email)
                        }
                        NotificationManager.runNotification(with: "\(activity.email)", subtitle: "\(activity.time):\n\(activity.title)", id: UUID().uuidString) { error in
                            if let error = error {
                                logger.error("\(error)")
                            }
                        }
                    }
                    
                }
            }
    }
    
    private func activityList(_ token: Token) -> AnyPublisher<(String, [V0ActivityEventResponseItemModel]), Error> {
        return Future<[V0ActivityEventResponseItemModel], Error> { promise in
            Task {
                do {
                    promise(.success(try await ActivityAPI(apiToken: token.token).activityList(limit: 1).data))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .map({ (token.email, $0) })
        .eraseToAnyPublisher()
    }
}
