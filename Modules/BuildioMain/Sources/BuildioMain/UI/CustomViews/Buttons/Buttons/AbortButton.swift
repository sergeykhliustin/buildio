//
//  AbortButton.swift
//  
//
//  Created by Sergey Khliustin on 26.01.2022.
//

import SwiftUI

struct AbortButton: View {
    private let action: () -> Void
    
    init(_ action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "nosign")
                Text("Abort")
            }
        }
        .buttonStyle(AbortButtonStyle())
    }
}
