//
//  AppRowView.swift
//  Modules
//
//  Created by Sergii Khliustin on 04.11.2024.
//

import Foundation
import SwiftUI
import Models
import Components

struct AppRowView: View {
    @Environment(\.theme) private var theme
    let model: V0AppResponseItemModel
    let isMuted: Bool
    let onMuteToggle: () -> Void

    init(model: V0AppResponseItemModel, isMuted: Bool, onMuteToggle: @escaping () -> Void) {
        self.model = model
        self.isMuted = isMuted
        self.onMuteToggle = onMuteToggle
    }

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            let statusColor = model.isDisabled ? theme.disabledColor.color : Color.clear
            Rectangle()
                .fill(statusColor)
                .frame(width: 5)
            HStack(spacing: 8) {
                WebImage(title: model.title, url: model.avatarUrl)
                    .frame(width: 40, height: 40)
                    .cornerRadius(8)
                
                PlatformIcon(model.projectType)
                    .frame(width: 20, height: 20)
                
                VStack(alignment: .leading) {
                    Text(model.title)
                        .font(.footnote.bold())
                    Text(model.owner.name)
                        .font(.footnote)
                }

            }
            .padding(.vertical, 8)
            Spacer()
            Image(isMuted ? .bell_slash : .bell)
                .padding()
                .button(action: onMuteToggle)
                .padding()
        }
    }
}

#Preview {
    VStack {
        AppRowView(model: .preview(), isMuted: false, onMuteToggle: {})
        AppRowView(model: .preview(), isMuted: true, onMuteToggle: {})
    }
}

