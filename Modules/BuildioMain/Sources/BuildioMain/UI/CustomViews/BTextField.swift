//
//  BTextField.swift
//  Buildio
//
//  Created by Sergey Khliustin on 12.10.2021.
//

import SwiftUI

struct BTextField: View {
    private let title: String
    private let text: Binding<String>
    private let onEditingChanged: (Bool) -> Void
    private let onCommit: () -> Void
    @State private var focused: Bool = false
    
    public init(_ title: String, text: Binding<String>, onEditingChanged: @escaping (Bool) -> Void = { _ in }, onCommit: @escaping () -> Void = {}) {
        self.title = title
        self.text = text
        self.onEditingChanged = onEditingChanged
        self.onCommit = onCommit
    }
    
    var body: some View {
        ZStack(alignment: .trailing) {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(focused ? Color.b_ButtonPrimaryLight : Color.b_BorderLight, lineWidth: 1)
                )
                .shadow(color: .b_ShadowLight, radius: 3, y: 2)
            TextField(title,
                      text: text,
                      onEditingChanged: { editing in
                self.focused = editing
                self.onEditingChanged(editing)
            }, onCommit: self.onCommit)
                .contentShape(Rectangle())
                .cornerRadius(4)
                .padding(.horizontal, 16)
        }
        .frame(height: 44)
    }
}

struct BTextField_Previews: PreviewProvider {
    static var previews: some View {
        BTextField("Text", text: .constant("text"))
    }
}
