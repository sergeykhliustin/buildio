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
import SwiftUI

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
    
    lazy var name: String = {
        var title = app.title.uppercased()
        return "\(title.first ?? "N")\(title.last ?? "A")"
    }()
    
    private lazy var color: Color = {
        let seed = [name.first, name.last].compactMap({ $0?.unicodeScalars.first?.value }).map({ Int($0) }).reduce(0, +)
        if seed > 0 {
            return Color.b_AvatarColors[seed % Color.b_AvatarColors.count]
        }
        return .white
    }()
    
    var backgroundColor: Color {
        if case .loading = state {
            return .white
        }
        return color
    }
    
    init(app: V0AppResponseItemModel) {
        self.app = app
        super.init()
    }
    
    override func fetch() -> AnyPublisher<UIImage, ErrorResponse> {
        ImageLoader().image(URL(str: app.avatarUrl))
    }
}
