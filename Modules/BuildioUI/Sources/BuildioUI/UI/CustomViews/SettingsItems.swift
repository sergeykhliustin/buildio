//
//  ActionItem.swift
//  
//
//  Created by Sergey Khliustin on 20.01.2022.
//

import SwiftUI

private struct SettingsIcon: View {
    let system: Images?
    
    var body: some View {
        if let system = system {
            Image(system)
                .frame(width: 20, height: 20, alignment: .center)
        }
    }
}

struct CheckmarkSettingsItem: View {
    let title: String
    let icon: Images?
    let selected: Bool
    let action: () -> Void
    
    init(title: String,
         icon: Images? = nil,
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
            SettingsIcon(system: icon)
        }, rightContent: {
            SettingsIcon(system: selected ? .checkmark : nil)
        }, action: action)
    }
}

struct SettingsItem: View {
    let title: String
    let icon: Images
    let action: () -> Void
    
    init(title: String,
         icon: Images,
         action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.action = action
    }
    
    var body: some View {
        ContentSettingsItem(title: title,
                          leftContent: {
            SettingsIcon(system: icon)
        }, rightContent: {
            EmptyView()
        }, action: action)
    }
}

struct NavigateSettingsItem: View {
    @Environment(\.theme) private var theme
    let title: String
    let icon: Images?
    let subtitle: String?
    let action: () -> Void
    
    init(title: String,
         icon: Images? = nil,
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
            SettingsIcon(system: icon)
        }, rightContent: {
            HStack {
                if let subtitle = subtitle {
                    Text(subtitle)
                        .foregroundColor(theme.textColorLight)
                }
                SettingsIcon(system: .chevron_right)
            }
        }, action: action)
    }
}

struct ToggleSettingsItem: View {
    let title: String
    let icon: Images?
    @Binding var toggle: Bool
    
    var body: some View {
        ContentSettingsItem(title: title,
                          leftContent: {
            SettingsIcon(system: icon)
        }, rightContent: {
            Toggle("", isOn: $toggle)
        }, action: { toggle.toggle() })
    }
}

struct SliderSettingsItem: View {
    @Environment(\.theme) private var theme
    let title: String
    let value: Binding<Double>
    
    var body: some View {
        ListItemWrapper {
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    Text(title)
                    Spacer(minLength: 0)
                    Slider(value: value, in: (0...60), step: 1)
                    if value.wrappedValue > 0 {
                        Text(String(Int(value.wrappedValue)) + "s")
                            .foregroundColor(theme.textColorLight)
                    } else {
                        Text("Disabled")
                            .foregroundColor(theme.textColorLight)
                    }
                }
                
            }
            .frame(height: 44)
            .defaultHorizontalPadding()
        }
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
        .defaultHorizontalPadding()
    }
}
