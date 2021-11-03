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
        HStack(alignment: .top) {
            let statusColor = model.status.color
            ZStack(alignment: .trailing) {
                RoundedRectangle(cornerRadius: 5)
                    .fill(statusColor)
                    .frame(width: 10)
                Rectangle()
                    .fill(statusColor)
                    .frame(width: 5)
            }
            
            VStack(alignment: .leading) {
                Group {
                    TagView(spacing: 4, content: { [
                        AnyView(
                            Text(model.title)
                                .foregroundColor(statusColor)
                                .padding(8)
                        ),
                        
                        AnyView(
                            Group {
                                Text(model.projectType)
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .lineLimit(1)
                            }
                                .background(Color(red: 0.27, green: 0.75, blue: 0.91))
                                .cornerRadius(4)
                        ),
                        
                        AnyView(
                            Text(model.owner.name)
                                .padding(8)
                                .border(Color.b_BorderLight, width: 2)
                                .cornerRadius(4)
                        )
                    ]
                    })
                        .font(.subheadline)
                    
                    Rectangle()
                        .fill(Color(red: 0.80, green: 0.80, blue: 0.80))
                        .frame(height: 4)
                }
                
                Rectangle()
                    .fill(Color(red: 0.80, green: 0.80, blue: 0.80))
                    .frame(height: 1)
            }
        }
        .padding([.leading, .trailing], 16)
        .font(.body)
        .foregroundColor(Color(red: 0.67, green: 0.67, blue: 0.67))
        .background(Color.white)
    }
}

struct AppRowView_Previews: PreviewProvider {
    static var previews: some View {
        AppRowView(model: V0AppResponseItemModel.preview())
    }
}
