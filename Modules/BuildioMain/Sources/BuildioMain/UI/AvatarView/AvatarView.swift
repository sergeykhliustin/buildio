//
//  AvatarView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 04.11.2021.
//

import SwiftUI
import Models

struct AvatarView: BaseView {
    @EnvironmentObject var model: AvatarViewModel
    
    var body: some View {
        SpacerWrapper {
            switch model.state {
            case .value:
                if let value = model.value {
                    Image(uiImage: value)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    EmptyView()
                }
                
            case .loading:
                ProgressView()
            case .error, .idle:
                if let name = model.name {
                    Text(name)
                        .foregroundColor(.white)
                        .font(.title2)
                }
            }
        }
        .background(model.backgroundColor)
        
    }
}
