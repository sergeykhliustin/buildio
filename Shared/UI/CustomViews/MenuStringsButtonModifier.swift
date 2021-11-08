//
//  MenuStringsButtonModifier.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 09.11.2021.
//

import Foundation
import SwiftUI

struct MenuStringsButtonModifier: ViewModifier {
    @Binding var strings: [String]?
    var onSelect: (String) -> Void
    let icon: String
    
    init(icon: String, strings: Binding<[String]?>, onSelect: @escaping (String) -> Void) {
        self.icon = icon
        self._strings = strings
        self.onSelect = onSelect
    }
    
    func body(content: Content) -> some View {
        ZStack(alignment: .trailing) {
            content
            
            if let strings = strings {
                Menu {
                    ForEach(strings, id: \.self) { string in
                        Button(string) {
                            onSelect(string)
                        }
                    }
                } label: {
                    Image(systemName: icon)
                }
                .padding(.trailing, 8)
            } else {
                ProgressView()
                    .padding(.trailing, 8)
            }
        }
    }
}
