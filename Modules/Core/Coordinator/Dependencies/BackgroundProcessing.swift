//
//  File.swift
//  
//
//  Created by Sergey Khliustin on 29.11.2021.
//

import BackgroundTasks
import API
import Combine
import Models
import Dependencies
import Logger
import UIKit

extension UserDefaults {
    struct Keys {
        static let lastActivityDates = "lastActivityDates"
    }
    func lastActivityDate(email: String) -> TimeInterval {
        if let double = dictionary(forKey: Keys.lastActivityDates)?[email] as? Double {
            return double
        }
        return 0
    }

    func setLastActivityDate(_ date: TimeInterval, email: String) {
        lastActivityDates[email] = date
    }

    private var lastActivityDates: [String: Double] {
        get {
            dictionary(forKey: Keys.lastActivityDates) as? [String: Double] ?? [:]
        }
        set {
            set(newValue, forKey: Keys.lastActivityDates)
            synchronize()
        }
    }
}

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

public final class BackgroundProcessing: @unchecked Sendable {
    public static let shared = BackgroundProcessing()
    private static let appRefreshTaskId = "buildio.appRefreshTask"

    private var settings: Settings

    private init() {
        self.settings = UserDefaults.standard.settings
    }

    private var timer: Timer?
    private var userDefaultsNotification: AnyObject?
    private var task: Task<Void, Never>?
    private var notificationCenterPubliser: AnyCancellable?

    public func start() {
        #if os(macOS) || targetEnvironment(macCatalyst)
        userDefaultsNotification = NotificationCenter.default.addObserver(forName: UserDefaults.didChangeNotification, object: nil, queue: nil) { [weak self] _ in
            guard let self else { return }
            if UserDefaults.standard.settings != self.settings {
                self.settings = UserDefaults.standard.settings
                self.restartTimer()
            }
        }
        
        restartTimer()
        #else
        BGTaskScheduler.shared.register(forTaskWithIdentifier: Self.appRefreshTaskId, using: nil, launchHandler: launchHandler)

        notificationCenterPubliser =
        NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification).sink { _ in

        } receiveValue: { [weak self] _ in
            self?.scheduleAppRefresh()
        }
        #endif
    }

    #if os(macOS) || targetEnvironment(macCatalyst)
    private func restartTimer() {
        timer?.invalidate()
        if settings.pollingInterval <= 0 {
            return
        }
        timer = Timer.scheduledTimer(withTimeInterval: settings.pollingInterval, repeats: true, block: { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            self.update()
        })
    }
    #else
    private var bgTask: BGTask?
    private lazy var launchHandler: (BGTask) -> Void = { [weak self] bgTask in
        let identifier = bgTask.identifier
        bgTask.expirationHandler = { [weak self] in
            logger.debug("[BGTASK \(identifier)] expired")
            self?.task?.cancel()
            self?.task = nil
            self?.bgTask = nil
        }
        self?.bgTask = bgTask
        self?.update()
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
    #endif

    func update() {
        task?.cancel()
        task = Task {
            let tokens = TokenManager().tokens
            let result = await withTaskGroup(of: ActivityNotification?.self) { group in
                for token in tokens {
                    group.addTask {
                        guard let result = try? await ActivityAPI(apiToken: token.token).activityList(limit: 1).data.first else { return nil }
                        return ActivityNotification(result, email: token.email)
                    }
                }
                let values = group.compactMap({ $0 })
                var result = [ActivityNotification]()
                for await value in values {
                    result.append(value)
                }
                return result
            }

            for item in result {
                if item.date.timeIntervalSince1970 > UserDefaults.standard.lastActivityDate(email: item.email) {
                    UserDefaults.standard.setLastActivityDate(item.date.timeIntervalSince1970, email: item.email)
                }
                if self.settings.muteAllNoPipeline && item.isMatchingPipeline {
                    continue
                }
                if let appName = item.appName,
                   self.settings.mutedApps[item.email]?.contains(appName) == true {
                    continue
                }
                NotificationManager.runNotification(with: "\(item.email)", subtitle: "\(item.time):\n\(item.title)", id: UUID().uuidString) { error in
                    if let error {
                        logger.error("\(error)")
                    }
                }
            }

            #if !targetEnvironment(macCatalyst) && !os(macOS)
            bgTask?.setTaskCompleted(success: true)
            self.scheduleAppRefresh()
            #endif
        }
    }
}
