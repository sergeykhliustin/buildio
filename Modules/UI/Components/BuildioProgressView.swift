//
//  ProgressArcShape.swift
//  Modules
//
//  Created by Sergii Khliustin on 03.11.2024.
//

import SwiftUI
import Combine

package struct BuildioProgressView: View {
    private var value: Double?
    package init(value: Double? = nil) {
        self.value = value
    }

    package var body: some View {
        ProgressView(value: value)
            .progressViewStyle(BuildioProgressViewStyle())
    }
}

private struct BuildioProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        if let progress = configuration.fractionCompleted {
            ProgressArcs(
                outerRotation: .degrees(360 * progress),
                innerRotation: .degrees(-360 * progress)
            )
        } else {
            TimelineView(.animation(minimumInterval: 0.01)) { timeline in
                let angle = Double(timeline.date.timeIntervalSince1970.remainder(dividingBy: 0.5)) * 720
                ProgressArcs(
                    outerRotation: .degrees(angle),
                    innerRotation: .degrees(-angle)
                )
            }
        }
    }
}

private struct ProgressArcShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.addArc(
                center: CGPoint(x: rect.midX, y: rect.midY),
                radius: rect.width / 2,
                startAngle: .degrees(90),
                endAngle: .degrees(180),
                clockwise: true
            )
        }.strokedPath(StrokeStyle(lineWidth: 3, lineCap: .round))
    }
}

// MARK: - Common Progress Components
private struct ProgressArcs: View {
    let outerRotation: Angle
    let innerRotation: Angle
    @Environment(\.theme) private var theme

    var body: some View {
        ZStack {
            ProgressArcShape()
                .frame(width: 20, height: 20)
                .foregroundColor(theme.accentColorLight.color)
                .rotationEffect(outerRotation)

            ProgressArcShape()
                .frame(width: 10, height: 10)
                .foregroundColor(theme.accentColor.color)
                .rotationEffect(innerRotation)
        }
    }
}

#Preview {
    VStack {
        // Infinite Progress Preview
        BuildioProgressView()

        // Determinate Progress Preview
        BuildioProgressView(value: 0.7)
            .progressViewStyle(CircularProgressViewStyle())
    }
}
