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
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
//        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
//                    radius: rect.width / 2,
//                    startAngle: Angle(degrees: 90),
//                    endAngle: Angle(degrees: 180), clockwise: true)
        return path.strokedPath(.init(lineWidth: rect.size.height, lineCap: .round))
    }
}

struct LinearProgressViewStyle: ProgressViewStyle {
    @Environment(\.theme) private var theme
    
    func makeBody(configuration: Configuration) -> some View {
        let progress = configuration.fractionCompleted ?? 0.0
        ZStack {
            GeometryReader { geometry in
                CustomProgressShape()
                    .foregroundColor(theme.accentColorLight)
                
                CustomProgressShape()
                    .foregroundColor(theme.accentColor)
                    .frame(width: geometry.size.width * progress)
                    .animation(.none)
            }
        }
        .frame(height: 2, alignment: .center)
    }
}

#if DEBUG
struct LinearProgressViewStyle_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView(value: 0.4)
            .progressViewStyle(LinearProgressViewStyle())
            .padding()
            .frame(alignment: .center)
    }
}
#endif
