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
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Group {
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
                Rectangle()
                    .fill(Color(red: 0.80, green: 0.80, blue: 0.80))
                    .frame(height: 1)
            }
        }
        .border(Color.b_BorderLight, width: 1)
        .cornerRadius(8)
        .padding([.leading, .trailing], 16)
        .font(.body)
        .multilineTextAlignment(.leading)
        .foregroundColor(Color(red: 0.67, green: 0.67, blue: 0.67))
        .background(Color.white)
    }
}

struct ActivityRowView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityRowView(model: V0ActivityEventResponseItemModel.preview())
    }
}
