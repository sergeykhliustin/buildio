//
//  AppRowView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 28.10.2021.
//

import SwiftUI
import Models

struct AppRowView: View {
    @State var model: V0AppResponseItemModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            let statusColor = model.status.color
            Rectangle()
                .fill(statusColor)
                .frame(width: 5)
            HStack(spacing: 8) {
                AvatarView(app: model)
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
        }
        .foregroundColor(.b_TextBlack)
    }
}

struct AppRowView_Previews: PreviewProvider {
    static var previews: some View {
        AppRowView(model: V0AppResponseItemModel.preview())
    }
}
