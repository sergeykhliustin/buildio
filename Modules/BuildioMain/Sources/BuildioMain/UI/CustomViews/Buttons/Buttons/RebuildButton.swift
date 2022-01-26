//
//  RebuildButton.swift
//  
//
//  Created by Sergey Khliustin on 26.01.2022.
//

import SwiftUI

struct RebuildButton: View {
    private let action: () -> Void
    
    init(_ action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "hammer")
                Text("Rebuild")
            }
        }
        .buttonStyle(SubmitButtonStyle(edgeInsets: EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)))
        .cornerRadius(20)
    }
}
