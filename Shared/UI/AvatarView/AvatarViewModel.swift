//
//  AvatarViewModel.swift
//  Buildio
//
//  Created by Sergey Khliustin on 04.11.2021.
//

import Foundation
import Combine
import SwiftUI
import BitriseAPIs

private extension URL {
    init?(str: String?) {
        if let string = str {
            self.init(string: string)
        } else {
            return nil
        }
    }
}

final class AvatarViewModel: BaseViewModel<UIImage> {
    let title: String?
    let url: String?
    
    init(title: String?, url: String?) {
        self.title = title
        self.url = url
    }
    
    lazy var name: String? = {
        if let title = title {
            var title = title.uppercased()
            return "\(title.first ?? "N")\(title.last ?? "A")"
        }
        return nil
    }()
    
    private lazy var color: Color = {
        return Color.fromString(name!)
    }()
    
    var backgroundColor: Color {
        if case .loading = state {
            return .white
        }
        if name == nil {
            return .white
        }
        return color
    }
    
    override func fetch(params: Any?) -> AnyPublisher<UIImage, ErrorResponse> {
        ImageLoader().image(URL(str: url))
    }
}
