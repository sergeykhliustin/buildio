//
//  CustomProgressView.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 22.11.2021.
//

import Foundation
import SwiftUI
import Combine

struct CustomProgressView: View {
    @State private var degrees: Double = 0.0
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0.0, to: 0.7)
                .stroke(Color.b_PrimaryLight, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.degrees(degrees))
                .onAppear {
                    withAnimation(.easeInOut(duration: 0.5).repeatForever()) {
                        degrees = 270
                    }
                }
                .frame(width: 20, height: 20, alignment: .center)
        }
    }
    
}
