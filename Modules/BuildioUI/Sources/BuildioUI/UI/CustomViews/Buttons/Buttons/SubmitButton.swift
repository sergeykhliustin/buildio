//
//  SubmitButton.swift
//  
//
//  Created by Sergey Khliustin on 26.01.2022.
//

import SwiftUI

struct SubmitButton: View {
    private let action: () -> Void
    init(_ action: @escaping () -> Void) {
        self.action = action
    }
    var body: some View {
        Button("Submit", action: action)
            .buttonStyle(SubmitButtonStyle())
            .cornerRadius(30)
        
    }
}
