//
//  RefreshableScrollView.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 22.11.2021.
//

import SwiftUI

struct RefreshableScrollView<Content: View>: View {
    @State private var previousScrollOffset: CGFloat = 0
    @State private var scrollOffset: CGFloat = 0
    @State private var rotation: Angle = .degrees(0)
    @State private var opacity: CGFloat = 0
    
    var threshold: CGFloat = 40
    @Binding var refreshing: Bool
    @ViewBuilder let content: () -> Content

    init(height: CGFloat = 60, refreshing: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) {
        self.threshold = height
        self._refreshing = refreshing
        self.content = content

    }
    
    var body: some View {
        return VStack(spacing: 0) {
            ScrollView {
                ZStack(alignment: .top) {
                    MovingView()
                    VStack(spacing: 0) {
                        SymbolView(threshold: self.threshold, height: self.scrollOffset > 0 ? self.scrollOffset : 0.0, loading: self.refreshing, rotation: self.rotation, opacity: self.opacity)
                        self.content()
                    }
                }
            }
            .background(FixedView())
            .onPreferenceChange(RefreshableKeyTypes.PrefKey.self) { values in
                self.refreshLogic(values: values)
            }
        }
    }
    
    private func refreshLogic(values: [RefreshableKeyTypes.PrefData]) {
        DispatchQueue.main.async {
            // Calculate scroll offset
            let movingBounds = values.first { $0.vType == .movingView }?.bounds ?? .zero
            let fixedBounds = values.first { $0.vType == .fixedView }?.bounds ?? .zero
            
            self.scrollOffset = movingBounds.minY - fixedBounds.minY
            
            self.rotation = self.symbolRotation(self.scrollOffset)
            self.opacity = self.symbolOpacity(self.scrollOffset)
            
            // Crossing the threshold on the way down, we start the refresh process
            if !self.refreshing && (self.scrollOffset > self.threshold && self.previousScrollOffset <= self.threshold) {
                withAnimation {
                    self.refreshing = true
                }
            }
            
            // Update last scroll offset
            self.previousScrollOffset = self.scrollOffset
        }
    }
    
    func symbolOpacity(_ scrollOffset: CGFloat) -> CGFloat {
        return scrollOffset / self.threshold
    }
    
    func symbolRotation(_ scrollOffset: CGFloat) -> Angle {
        
        // We will begin rotation, only after we have passed
        // 60% of the way of reaching the threshold.
        if scrollOffset < self.threshold * 0.60 {
            return .degrees(0)
        } else {
            // Calculate rotation, based on the amount of scroll offset
            let h = Double(self.threshold)
            let d = Double(scrollOffset)
            let v = max(min(d - (h * 0.6), h * 0.4), 0)
            return .degrees(180 * v / (h * 0.4))
        }
    }
    
    struct SymbolView: View {
        var threshold: CGFloat
        var height: CGFloat
        var loading: Bool
        var rotation: Angle
        var opacity: CGFloat
        
        var body: some View {
            Group {
                if self.loading { // If loading, show the activity control
                    VStack {
                        Spacer()
                        ProgressView().progressViewStyle(CustomProgressViewStyle())
                        Spacer()
                    }.frame(height: threshold).fixedSize()
                } else {
                    Image(systemName: "arrow.down") // If not loading, show the arrow
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: height * 0.25, height: height * 0.25).fixedSize()
                        .padding(height * 0.375)
                        .rotationEffect(rotation)
                        .opacity(opacity)
                }
            }
        }
    }
    
    private struct MovingView: View {
        var body: some View {
            GeometryReader { proxy in
                Color.clear.preference(key: RefreshableKeyTypes.PrefKey.self, value: [RefreshableKeyTypes.PrefData(vType: .movingView, bounds: proxy.frame(in: .global))])
            }.frame(height: 0)
        }
    }
    
    private struct FixedView: View {
        var body: some View {
            GeometryReader { proxy in
                Color.clear.preference(key: RefreshableKeyTypes.PrefKey.self, value: [RefreshableKeyTypes.PrefData(vType: .fixedView, bounds: proxy.frame(in: .global))])
            }
        }
    }
}

private struct RefreshableKeyTypes {
    enum ViewType: Int {
        case movingView
        case fixedView
    }

    struct PrefData: Equatable {
        let vType: ViewType
        let bounds: CGRect
    }

    struct PrefKey: PreferenceKey {
        static var defaultValue: [PrefData] = []

        static func reduce(value: inout [PrefData], nextValue: () -> [PrefData]) {
            value.append(contentsOf: nextValue())
        }

        typealias Value = [PrefData]
    }
}
