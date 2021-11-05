//
//  AvatarView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 04.11.2021.
//

import SwiftUI
import Models

struct AvatarView: BaseView {
    @StateObject var model: AvatarViewModel
    
    init(app: V0AppResponseItemModel) {
        self._model = StateObject(wrappedValue: AvatarViewModel(title: app.title, url: app.avatarUrl))
    }
    
    init(user: V0UserProfileDataModel) {
        self._model = StateObject(wrappedValue: AvatarViewModel(title: user.username ?? user.email, url: user.avatarUrl))
    }
    
    init(string: String) {
        self._model = StateObject(wrappedValue: AvatarViewModel(title: string, url: nil))
    }
    
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
                Text(model.name)
                    .foregroundColor(.white)
            }
        }
        .background(model.backgroundColor)
        
    }
}

struct ImageURL_Previews: PreviewProvider {
    static var previews: some View {
        AvatarView(app: V0AppResponseItemModel.preview())
            .frame(width: 40, height: 40)
    }
}
