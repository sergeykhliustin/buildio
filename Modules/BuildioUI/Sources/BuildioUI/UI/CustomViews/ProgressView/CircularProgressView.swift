//
//  CustomProgressView.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 22.11.2021.
//

import Foundation
import SwiftUI
import Combine

private struct CustomProgressShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
                    radius: rect.width / 2,
                    startAngle: Angle(degrees: 90),
                    endAngle: Angle(degrees: 180), clockwise: true)
        return path.strokedPath(.init(lineWidth: 3, lineCap: .round))
    }
}

struct CircularInfiniteProgressViewStyle: ProgressViewStyle {
    @Environment(\.theme) private var theme
    @State private var isAnimating = false
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            CustomProgressShape()
                .frame(width: 20, height: 20, alignment: .center)
                .foregroundColor(theme.accentColorLight)
                .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
            
            CustomProgressShape()
                .frame(width: 10, height: 10, alignment: .center)
                .foregroundColor(theme.accentColor)
                .rotationEffect(Angle(degrees: isAnimating ? -360 : 0))
        }
        .onAppear {
            withAnimation(animation) {
                isAnimating = true
            }
        }
        .onDisappear { isAnimating = false }
    }
    
    private var animation: Animation {
        .linear(duration: 0.5).repeatForever(autoreverses: false)
    }
}

struct CircularProgressViewStyle: ProgressViewStyle {
    @Environment(\.theme) private var theme
    
    func makeBody(configuration: Configuration) -> some View {
        let progress = configuration.fractionCompleted ?? 0.0
        ZStack {
            CustomProgressShape()
                .frame(width: 20, height: 20, alignment: .center)
                .foregroundColor(theme.accentColorLight)
                .rotationEffect(Angle(degrees: 360 * progress ))
                .animation(.none)
            
            CustomProgressShape()
                .frame(width: 10, height: 10, alignment: .center)
                .foregroundColor(theme.accentColor)
                .rotationEffect(Angle(degrees: -360 * progress))
                .animation(.none)
        }
    }
}

#if DEBUG
struct CircularProgressViewStyle_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
            .progressViewStyle(CircularInfiniteProgressViewStyle())
    }
}
#endif
