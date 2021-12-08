//
//  CustomProgressView.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 22.11.2021.
//

import Foundation
import SwiftUI
import Combine

struct CustomProgressViewStyle: ProgressViewStyle {
    @State private var isAnimating = false
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            CustomShape()
                .frame(width: 20, height: 20, alignment: .center)
                .foregroundColor(.b_PrimaryLight)
                .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                .animation(isAnimating ? animation : .none)
            
            CustomShape()
                .frame(width: 10, height: 10, alignment: .center)
                .foregroundColor(.b_Primary)
                .rotationEffect(Angle(degrees: isAnimating ? -360 : 0))
                .animation(isAnimating ? animation : .none)
        }
        .onAppear { isAnimating = true }
        .onDisappear { isAnimating = false }
    }
    
    private var animation: Animation {
        .linear(duration: 0.5).repeatForever(autoreverses: false)
    }
    
    private struct CustomShape: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
                        radius: rect.width / 2,
                        startAngle: Angle(degrees: 90),
                        endAngle: Angle(degrees: 180), clockwise: true)
            return path.strokedPath(.init(lineWidth: 3, lineCap: .round))
        }
    }
}

#if DEBUG
struct CustomProgressViewStyle_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
            .progressViewStyle(CustomProgressViewStyle())
    }
}
#endif
