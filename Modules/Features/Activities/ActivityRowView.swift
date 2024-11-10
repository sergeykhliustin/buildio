//
//  ActivityRowView.swift
//  Modules
//
//  Created by Sergii Khliustin on 05.11.2024.
//

import Foundation
import SwiftUI
import Models
import Components

struct ActivityRowView: View {
    @Environment(\.theme) private var theme
    let model: V0ActivityEventResponseItemModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            WebImage(title: model.repositoryTitle ?? "", url: model.eventIcon ?? model.repositoryAvatarIconUrl)
                .frame(width: 40, height: 40)
                .rounded()
                .padding(.top, 8)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(model.description ?? model.title ?? model.repositoryTitle ?? model.eventStype ?? "")
                    .lineLimit(10)
                Text("@ \(model.createdAt.full)").foregroundColor(theme.textColorLight.color)
            }
            .padding(8)
            Spacer()
        }
        .padding([.leading, .trailing], 8)
        .font(.footnote)
        .multilineTextAlignment(.leading)
    }
}

#Preview {
    ActivityRowView(model: .preview())
}
