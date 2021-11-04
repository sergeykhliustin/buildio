//
//  LIstItemWrapper.swift
//  Buildio
//
//  Created by Sergey Khliustin on 04.11.2021.
//

import SwiftUI

struct ListItemWrapper<Content>: View where Content: View {
    @ViewBuilder var content: (Bool) -> Content
    @State private var isHighLighted: Bool = false
    var action: (() -> Void)?
    
    init(_ content: @escaping (_ highlighted: Bool) -> Content, action: (() -> Void)?) {
        self.content = content
        self.action = action
    }
    
    var body: some View {
        content(isHighLighted)
            .onTapGesture {
                action?()
            }
    }
}
