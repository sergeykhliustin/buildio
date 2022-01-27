//
//  ActivityRowView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 03.11.2021.
//

import SwiftUI
import Models

struct ActivityRowView: View {
    @Environment(\.theme) private var theme
    @EnvironmentObject private var screenFactory: ScreenFactory
    var model: V0ActivityEventResponseItemModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            screenFactory
                .avatarView(title: model.repositoryTitle, url: model.eventIcon ?? model.repositoryAvatarIconUrl)
                .frame(width: 40, height: 40)
                .cornerRadius(8)
                .padding(.top, 8)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(model.description ?? model.title ?? model.repositoryTitle ?? model.eventStype ?? "")
                Text("@ \(model.createdAt.full)").foregroundColor(theme.textColorLight)
            }
            .padding(8)
            Spacer()
        }
        .padding([.leading, .trailing], 8)
        .font(.footnote)
        .multilineTextAlignment(.leading)
    }
}

struct ActivityRowView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityRowView(model: V0ActivityEventResponseItemModel.preview())
    }
}
