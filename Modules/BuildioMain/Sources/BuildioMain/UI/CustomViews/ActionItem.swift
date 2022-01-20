//
//  ActionItem.swift
//  
//
//  Created by Sergey Khliustin on 20.01.2022.
//

import SwiftUI

struct IconActionItem: View {
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
        ContentActionItem(title: title,
                          leftContent: {
            Image(systemName: icon)
        }, rightContent: {
            Image(systemName: "chevron.right")
        }, action: action)
    }
}

struct ColorActionItem: View {
    let title: String
    let color: Color
    let action: (() -> Void)?
    @State var cgColor: CGColor = Color.clear.cgColor!
    
    init(title: String,
         color: Color,
         action: (() -> Void)? = nil) {
        self.title = title
        self.color = color
        self.action = action
    }
    
    var body: some View {
        ContentActionItem(title: title,
                          leftContent: {
            ColorPicker(title, selection: $cgColor)
//            color.frame(width: 20, height: 20).cornerRadius(2)
        }, rightContent: {
            Image(systemName: "chevron.right")
        }, action: action)
    }
}

struct ToggleActionItem: View {
    let title: String
    let icon: String
    @Binding var toggle: Bool
    
    var body: some View {
        ContentActionItem(title: title,
                          leftContent: {
            Image(systemName: icon)
        }, rightContent: {
            Toggle("", isOn: $toggle)
        }, action: { toggle.toggle() })
    }
}

struct ContentActionItem<LeftContent: View, RightContent: View>: View {
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
