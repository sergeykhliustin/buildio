//
//  ActionItem.swift
//  
//
//  Created by Sergey Khliustin on 20.01.2022.
//

import SwiftUI

private struct SettingsIcon: View {
    let systemName: String
    
    var body: some View {
        Image(systemName: systemName)
            .frame(width: 20, height: 20, alignment: .center)
    }
}

struct CheckmarkSettingsItem: View {
    let title: String
    let icon: String
    let selected: Bool
    let action: () -> Void
    
    init(title: String,
         icon: String,
         selected: Bool,
         action: @escaping () -> Void) {
        self.selected = selected
        self.title = title
        self.icon = icon
        self.action = action
    }
    
    var body: some View {
        ContentSettingsItem(title: title,
                          leftContent: {
            EmptyView()
        }, rightContent: {
            SettingsIcon(systemName: selected ? "checkmark" : "")
        }, action: action)
    }
}

struct SettingsItem: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    init(title: String,
         icon: String,
         action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.action = action
    }
    
    var body: some View {
        ContentSettingsItem(title: title,
                          leftContent: {
            SettingsIcon(systemName: icon)
        }, rightContent: {
            EmptyView()
        }, action: action)
    }
}

struct NavigateSettingsItem: View {
    @Environment(\.theme) private var theme
    let title: String
    let icon: String
    let subtitle: String?
    let action: () -> Void
    
    init(title: String,
         icon: String,
         subtitle: String? = nil,
         action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.subtitle = subtitle
        self.action = action
    }
    
    var body: some View {
        ContentSettingsItem(title: title,
                          leftContent: {
            SettingsIcon(systemName: icon)
        }, rightContent: {
            HStack {
                if let subtitle = subtitle {
                    Text(subtitle)
                        .foregroundColor(theme.textColorLight)
                }
                SettingsIcon(systemName: "chevron.right")
            }
        }, action: action)
    }
}

struct ToggleSettingsItem: View {
    let title: String
    let icon: String
    @Binding var toggle: Bool
    
    var body: some View {
        ContentSettingsItem(title: title,
                          leftContent: {
            SettingsIcon(systemName: icon)
        }, rightContent: {
            Toggle("", isOn: $toggle)
        }, action: { toggle.toggle() })
    }
}

struct ContentSettingsItem<LeftContent: View, RightContent: View>: View {
    let title: String
    let leftContent: (() -> LeftContent)?
    let rightContent: (() -> RightContent)?
    let action: (() -> Void)?
    
    init(title: String,
         leftContent: (() -> LeftContent)? = nil,
         rightContent: (() -> RightContent)? = nil,
         action: (() -> Void)? = nil) {
        self.title = title
        self.leftContent = leftContent
        self.rightContent = rightContent
        self.action = action
    }
    
    var body: some View {
        ListItemWrapper(action: action) {
            HStack(spacing: 8) {
                leftContent?()
                Text(title)
                Spacer(minLength: 0)
                rightContent?()
            }
            .frame(height: 44)
            .padding(.horizontal, 16)
        }
    }
}
