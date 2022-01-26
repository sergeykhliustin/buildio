//
//  StartBuildButton.swift
//  
//
//  Created by Sergey Khliustin on 26.01.2022.
//

import SwiftUI

struct StartBuildButton: View {
    private let title: String
    private let action: () -> Void
    
    init(_ title: String, _ action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text("🚀 \(title)")
            }
        }
        .buttonStyle(SubmitButtonStyle(edgeInsets: EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)))
        .cornerRadius(20)
    }
}

#if DEBUG
struct RebuildButton_Preview: PreviewProvider {
    static var previews: some View {
        StartBuildButton("Start", {})
    }
}
#endif
