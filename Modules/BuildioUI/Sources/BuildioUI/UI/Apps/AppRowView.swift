//
//  AppRowView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 28.10.2021.
//

import SwiftUI
import Models
import BuildioLogic

struct AppRowView: View {
    @EnvironmentObject private var screenFactory: ScreenFactory
    @Environment(\.theme) private var theme
    @State var model: V0AppResponseItemModel
    @EnvironmentObject private var accountSettings: AccountSettingsManager
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            let statusColor = model.isDisabled ? theme.disabledColor : Color.clear
            Rectangle()
                .fill(statusColor)
                .frame(width: 5)
            HStack(spacing: 8) {
                screenFactory
                    .avatarView(app: model)
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
            Button(action: {
                accountSettings.toggleMuted(app: model)
            }, label: {
                Image(accountSettings.isMuted(app: model) ? .bell_slash : .bell)
                    .padding()
            })
            .padding()
        }
    }
}

struct AppRowView_Previews: PreviewProvider {
    static var previews: some View {
        AppRowView(model: V0AppResponseItemModel.preview())
    }
}
