//
//  View+Additions.swift
//  
//
//  Created by Sergey Khliustin on 09.12.2021.
//

import SwiftUI

extension View {
    var hosting: UIHostingController<Self> {
        return UIHostingController(rootView: self)
    }
    
    func eraseToAnyView() -> AnyView {
        return AnyView(self)
    }
}
