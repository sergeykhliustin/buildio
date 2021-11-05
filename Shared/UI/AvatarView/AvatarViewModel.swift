//
//  AvatarViewModel.swift
//  Buildio
//
//  Created by Sergey Khliustin on 04.11.2021.
//

import Foundation
import Combine
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

final class AvatarViewModel: BaseViewModel<UIImage> {
    let title: String
    let url: String?
    
    init(title: String, url: String?) {
        self.title = title
        self.url = url
    }
    
    lazy var name: String = {
        var title = title.uppercased()
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
    
    override func fetch() -> AnyPublisher<UIImage, ErrorResponse> {
        ImageLoader().image(URL(str: url))
    }
}
