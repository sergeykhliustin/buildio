//
//  ActivitiesPageModel.swift
//  Modules
//
//  Created by Sergii Khliustin on 05.11.2024.
//

import Foundation
import Models
import API
import UITypes
import Dependencies
import Logger
import UserNotifications
#if os(iOS)
import UIKit
#endif

package final class ActivitiesPageModel: PageModelType {
    enum NotificationsAuthorization {
        case authorized
        case notDetermined
        case other
    }
    private let fetchLimit: Int = 30
    @Published private(set) var data: V0ActivityEventListResponseModel?
    @Published var notificationsAuthorization: NotificationsAuthorization?

    deinit {
        logger.debug("Deinit \(self)")
    }

    package override init(dependencies: DependenciesType) {
        super.init(dependencies: dependencies)
        refresh()
        subscribeActivities { [weak self] in
            self?.refresh()
        }
    }

    func refresh() {
        guard !isLoading else { return }
        isLoading = true
        DispatchQueue.global().async {
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                let status: NotificationsAuthorization
                switch settings.authorizationStatus {
                case .authorized:
                    status = .authorized
                case .notDetermined:
                    status = .notDetermined
                default:
                    status = .other
                }
                DispatchQueue.main.async { [weak self] in
                    self?.notificationsAuthorization = status
                }
            }
        }
        Task {
            do {
                self.data = try await dependencies.apiFactory
                    .api(ActivityAPI.self)
                    .activityList(limit: fetchLimit)
            } catch {
                onError(error)
            }
            isLoading = false
        }
    }

    var canLoadMore: Bool {
        data?.paging.next != nil
    }

    func loadMore() {
        guard !isLoading, let next = data?.paging.next else { return }
        isLoading = true
        Task {
            do {
                var data = try await dependencies.apiFactory
                    .api(ActivityAPI.self)
                    .activityList(next: next, limit: fetchLimit)
                data.data = (self.data?.data ?? []) + data.data
                self.data = data
            } catch {
                onError(error)
            }
            isLoading = false
        }
    }

    func onActivity(_ item: V0ActivityEventResponseItemModel) {
        let targetComponents = item.targetPathString?.split(separator: "/")
        guard !isLoading,
              item.eventStype == "build",
              let components = targetComponents,
              components.count == 2,
              components.first == "build",
              let appName = item.appName,
              !appName.isEmpty else { return }
        isLoading = true
        Task {
            defer {
                isLoading = false
            }
            let buildSlug = components[1]
            guard let app = try? await dependencies.apiFactory
                .api(ApplicationAPI.self)
                .appList(title: appName).data
                .first(where: { $0.title == appName }) else {
                return
            }
            guard var build = try? await dependencies.apiFactory
                .api(BuildsAPI.self)
                .buildShow(appSlug: app.slug, buildSlug: String(buildSlug)).data
            else { return }
            build.repository = app

            dependencies.navigator.show(.build(build))
        }
    }

    func onNotifications() {
        guard let notificationsAuthorization, notificationsAuthorization != .authorized else { return }
        if notificationsAuthorization == .notDetermined {
            Task {
                let granted = try? await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
                if granted == true {
                    self.notificationsAuthorization = .authorized
                } else {
                    refresh()
                }
            }
        } else {
            #if os(iOS)
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings)
            }
            #endif
        }
    }
}
