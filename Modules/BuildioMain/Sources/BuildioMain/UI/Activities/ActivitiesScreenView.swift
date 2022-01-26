//
//  ActivitiesScreenView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 03.11.2021.
//

import SwiftUI
import Models

struct ActivitiesScreenView: PagingView {
    @EnvironmentObject var model: ActivitiesViewModel
    @Environment(\.openURL) private var openURL
    @State private var notificationsAuthorization: UNAuthorizationStatus?
    
    func headerBody() -> some View {
        if let notificationsAuthorization = notificationsAuthorization, notificationsAuthorization != .authorized {
            NavigateSettingsItem(title: "Enable notifications", icon: "bell") {
                if notificationsAuthorization == .notDetermined {
                    Task {
                        let granted = try? await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
                        if granted == true {
                            self.notificationsAuthorization = .authorized
                        } else {
                            checkNotifications()
                        }
                    }
                } else if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
                    openURL(appSettings)
                }
            }
        }
    }
    
    func buildItemView(_ item: V0ActivityEventResponseItemModel) -> some View {
        ListItemWrapper(action: {
            
        }, content: {
            ActivityRowView(model: item)
        })
    }
    
    func onAppear() {
        checkNotifications()
    }
    
    private func checkNotifications() {
        Task {
            self.notificationsAuthorization = await UNUserNotificationCenter.current().notificationSettings().authorizationStatus
        }
    }
}

struct ActivitiesScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ActivitiesScreenView()
    }
}
