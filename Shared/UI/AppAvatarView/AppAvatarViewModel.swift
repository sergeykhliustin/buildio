//
//  AppAvatarViewModel.swift
//  Buildio
//
//  Created by Sergey Khliustin on 04.11.2021.
//

import Foundation
import UIKit
import Combine
import Models

private extension URL {
    init?(str: String?) {
        if let string = str {
            self.init(string: string)
        } else {
            return nil
        }
    }
}

final class AppAvatarViewModel: BaseViewModel<UIImage> {
    var app: V0AppResponseItemModel
    
    init(app: V0AppResponseItemModel) {
        self.app = app
        super.init()
    }
    
    override func fetch() -> AnyPublisher<UIImage, ErrorResponse> {
        ImageLoader().image(URL(str: app.avatarUrl))
    }
}
