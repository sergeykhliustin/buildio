//
//  TagView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 26.10.2021.
//

import SwiftUI

struct TagView: View {
    var spacing: CGFloat = 4
    let content: () -> [AnyView]

    @State private var totalHeight = CGFloat.zero

    var body: some View {
        VStack {
            GeometryReader { geometry in
                self.generateContent(in: geometry)
            }
        }
        .frame(height: totalHeight)
    }

    private func generateContent(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        let content = content()

        return ZStack(alignment: .topLeading) {
            ForEach((0..<content.count)) { index in
                content[index]
                    .padding([.horizontal], spacing)
                    .alignmentGuide(.leading, computeValue: { dimensions in
                        if abs(width - dimensions.width) > geometry.size.width {
                            width = 0
                            height -= dimensions.height
                        }
                        let result = width
                        if index == content.count - 1 {
                            width = 0
                        } else {
                            width -= dimensions.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { dimensions in
                        let result = height
                        if index == content.count - 1 {
                            height = 0 // last item
                        }
                        return result
                    })
            }
        }.background(viewHeightReader($totalHeight))
    }

    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
}
