//
//  CustomTabBar.swift
//  Buildio
//
//  Created by Sergey Khliustin on 05.11.2021.
//

import SwiftUI

private struct CustomTabBarButtonStyle: ButtonStyle {
    let selected: Bool
    @State private var hover: Bool = false
    
    func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        let highlighted = selected || configuration.isPressed || hover
        configuration
            .label
            .contentShape(Rectangle())
            .foregroundColor(highlighted ? Color.b_Primary : Color.b_PrimaryLight)
//            .background(
//                RoundedRectangle(cornerRadius: 4).stroke(highlighted ? Color.b_Primary : .clear, lineWidth: 1)
//            )
            .onHover { hover in
                self.hover = hover
            }
    }
}

struct CustomTabBar<Content>: View where Content: View {
    @Binding var selected: Int
    @ViewBuilder var content: (Int) -> Content
    private let count: Int
    private let spacing: CGFloat

    init(spacing: CGFloat = 4, count: Int, selected: Binding<Int>, @ViewBuilder content: @escaping (Int) -> Content) {
        self.spacing = spacing
        self.count = count
        self._selected = selected
        self.content = content
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            ForEach(0..<count) { index in
                
                Button(action: {
                    selected = index
                }, label: {
                    VStack(spacing: 0) {
                        content(index)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                })
                    .buttonStyle(CustomTabBarButtonStyle(selected: selected == index))
                Spacer()
            }
        }
        .frame(height: 48)
        .background(Color.white.shadow(color: .b_ShadowLight, radius: 3, y: -5))
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar(count: 2, selected: .constant(0)) { _ in
            Image(systemName: "hammer.fill")
                .frame(maxWidth: .infinity)
            Text("Builds")
                .frame(maxWidth: .infinity)
        }
    }
}
