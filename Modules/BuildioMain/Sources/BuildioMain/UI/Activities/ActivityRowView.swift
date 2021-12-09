//
//  ActivityRowView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 03.11.2021.
//

import SwiftUI
import Models

struct ActivityRowView: View {
    var model: V0ActivityEventResponseItemModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            AvatarView(title: model.repositoryTitle, url: model.eventIcon ?? model.repositoryAvatarIconUrl)
                .frame(width: 40, height: 40)
                .cornerRadius(8)
                .padding(.top, 8)
            
            VStack(alignment: .leading) {
                
                Text("Created @ \(model.createdAt.full)")
                
                if let title = model.title {
                    Text(title)
                }
                
                if let description = model.description {
                    Text(description)
                }
                
                if let repoTitle = model.repositoryTitle {
                    Text(repoTitle)
                }
                
                if let eventStype = model.eventStype {
                    Text(eventStype)
                }
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
