//
//  StartBuildButton.swift
//  Modules
//
//  Created by Sergii Khliustin on 05.11.2024.
//

import SwiftUI

package struct StartBuildButton: View {
    private let title: String
    private let action: () -> Void
    
    package init(_ title: String, _ action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    package var body: some View {
        Button(action: action) {
            HStack {
                Text("🚀 \(title)")
            }
        }
        .buttonStyle(SubmitButtonStyle(edgeInsets: EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)))
        .cornerRadius(20)
    }
}

#Preview {
    StartBuildButton("Start Build") {}
}
