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
    @State private var degrees: Double = 0.0
    
    func makeBody(configuration: Configuration) -> some View {
        Circle()
            .trim(from: 0.0, to: 0.7)
            .stroke(Color.b_PrimaryLight, style: StrokeStyle(lineWidth: 4, lineCap: .round))
            .frame(width: 20, height: 20, alignment: .center)
            .fixedSize()
            .rotationEffect(.degrees(degrees))
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 0.5).repeatForever()) {
                    degrees = 270
                }
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
