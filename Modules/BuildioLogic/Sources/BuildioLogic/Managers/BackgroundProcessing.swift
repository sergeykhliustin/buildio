//
//  File.swift
//  
//
//  Created by Sergey Khliustin on 29.11.2021.
//

import BackgroundTasks
import BitriseAPIs
import Combine
import Models

#if canImport(UIKit)
import UIKit
#endif

private struct ActivityNotification {
    let email: String
    let title: String
    let date: Date
    let appName: String?
    let isMatchingPipeline: Bool
    
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
        self.appName = item.appName
        self.isMatchingPipeline = item.isMatchingPipeline
    }
}

#if !os(macOS)
public final class BackgroundProcessing {
    public static let shared = BackgroundProcessing()
    
    private static let appRefreshTaskId = "buildio.appRefreshTask"
    private init() {}
    
    private var fetcher: AnyCancellable?
    private var longFetcher: AnyCancellable?
    private var notificationCenterPubliser: AnyCancellable?
    
    public func start() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: Self.appRefreshTaskId, using: nil, launchHandler: launchHandler)
        
        notificationCenterPubliser =
        NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification).sink { _ in
            
        } receiveValue: { [weak self] _ in
            self?.scheduleAppRefresh()
        }
    }
    
    private lazy var launchHandler: (BGTask) -> Void = { [weak self] task in
        let identifier = task.identifier
        logger.debug("[BGTASK] Perform bg fetch \(identifier)")
        if var count = UserDefaults.standard.backgroundAnalytics[identifier] {
            count += 1
            UserDefaults.standard.backgroundAnalytics[identifier] = count
        } else {
            UserDefaults.standard.backgroundAnalytics[identifier] = 1
        }
        guard let self = self else {
            logger.debug("[BGTASK] AppDelegate is nil")
            return
        }
        let accountsSettings = UserDefaults.standard.accountsSettings
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
                task.setTaskCompleted(success: true)
                self?.scheduleAppRefresh()
            } receiveValue: { result in
                DispatchQueue.main.async { [weak self] in
                    result.forEach { activity in
                        if activity.date.timeIntervalSince1970 > UserDefaults.standard.lastActivityDate(email: activity.email) {
                            UserDefaults.standard.setLastActivityDate(activity.date.timeIntervalSince1970, email: activity.email)
                        }
                        if self?.shouldPublishNotification(activity, with: accountsSettings) == true {
                            NotificationManager.runNotification(with: "\(activity.email)",
                                                                subtitle: "\(activity.time):\n\(activity.title)",
                                                                id: UUID().uuidString) { error in
                                if let error = error {
                                    logger.error("[BGTASK \(identifier)] \(error)")
                                }
                            }
                        }
                    }
                    
                }
            }

        task.expirationHandler = { [weak self] in
            logger.debug("[BGTASK \(identifier)] expired")
            self?.fetcher?.cancel()
        }
    }

    private func shouldPublishNotification(_ activity: ActivityNotification, with settings: [String: AccountSettings]) -> Bool {
        guard !(UserDefaults.standard.isMatchingPipelineMuted && activity.isMatchingPipeline) else {
            return false
        }
        guard let appName = activity.appName else {
            return true
        }
        return settings[activity.email]?.mutedApps.contains(appName) != true
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
    
    private func scheduleAppRefresh() {
        BGTaskScheduler.shared.getPendingTaskRequests { tasks in
            if !tasks.contains(where: { $0.identifier == Self.appRefreshTaskId }) {
                logger.debug("[\(Self.appRefreshTaskId)] scheduling app refresh")
                let request = BGAppRefreshTaskRequest(identifier: Self.appRefreshTaskId)
                request.earliestBeginDate = Date(timeIntervalSinceNow: 0)
                
                do {
                    try BGTaskScheduler.shared.submit(request)
                    logger.debug("[\(Self.appRefreshTaskId)] submitted")
                } catch {
                    let error = error
                    logger.debug("Could not schedule \(Self.appRefreshTaskId) \(error)")
                }
            }
        }
    }
}
#endif
