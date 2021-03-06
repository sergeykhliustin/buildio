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

public final class AvatarViewModel: BaseViewModel<UIImage>, CacheableViewModel {
    override class var shouldRefreshOnInit: Bool {
        return true
    }
    
    let title: String?
    let url: String?
    
    init(title: String?, url: String?) {
        self.title = title
        self.url = url
        super.init()
    }
    
    public lazy var name: String? = {
        if let title = title {
            var title = title.uppercased()
            return "\(title.first ?? "N")\(title.last ?? "A")"
        }
        return nil
    }()
    
    private lazy var color: Color = {
        return Color.fromString(name!)
    }()
    
    public var backgroundColor: Color {
        if case .loading = state {
            return .white
        }
        if name == nil {
            return .white
        }
        return color
    }
    
    override func fetch() async throws -> UIImage {
        try await ImageLoader().image(URL(str: url))
    }
}
