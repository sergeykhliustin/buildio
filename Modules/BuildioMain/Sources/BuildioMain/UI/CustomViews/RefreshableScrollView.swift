//
//  RefreshableScrollView.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 22.11.2021.
//

import SwiftUI

struct RefreshableScrollView<Content: View>: View {
    @State private var previousScrollOffset: CGFloat = 0
    @State private var progress: CGFloat = 0
    
    var threshold: CGFloat = 40
    @Binding var refreshing: Bool
    @ViewBuilder let content: () -> Content

    init(height: CGFloat = 40, refreshing: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) {
        self.threshold = height
        self._refreshing = refreshing
        self.content = content

    }
    
    var body: some View {
        ScrollView {
            ZStack(alignment: .top) {
                MovingView()
                SymbolView(threshold: self.threshold,
                           loading: self.refreshing,
                           progress: self.progress)
                
                self.content()
                    .offset(x: 0, y: threshold * progress)
            }
        }
        .background(FixedView())
        .onPreferenceChange(RefreshableKeyTypes.PrefKey.self) { values in
            self.refreshLogic(values: values)
        }
    }
    
    private func refreshLogic(values: [RefreshableKeyTypes.PrefData]) {
        DispatchQueue.main.async {
            // Calculate scroll offset
            let movingBounds = values.first { $0.vType == .movingView }?.bounds ?? .zero
            let fixedBounds = values.first { $0.vType == .fixedView }?.bounds ?? .zero
            
            let scrollOffset = movingBounds.minY - fixedBounds.minY
            
            self.progress = symbolProgress(scrollOffset)
            
            // Crossing the threshold on the way down, we start the refresh process
            if !self.refreshing && (scrollOffset > self.threshold && self.previousScrollOffset <= self.threshold) {
                withAnimation {
                    self.refreshing = true
                }
            }
            
            // Update last scroll offset
            self.previousScrollOffset = scrollOffset
        }
    }
    
    private func symbolProgress(_ scrollOffset: CGFloat) -> CGFloat {
        if scrollOffset < 0 {
            return 0
        }
        return min(scrollOffset / threshold, 1.0)
    }
    
    private func symbolOpacity(_ scrollOffset: CGFloat) -> CGFloat {
        return scrollOffset / self.threshold
    }
    
    private func symbolRotation(_ scrollOffset: CGFloat) -> Angle {
        
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
        var loading: Bool
        var progress: CGFloat
        
        var body: some View {
            Group {
                if self.loading { // If loading, show the activity control
                    VStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }.frame(height: threshold).fixedSize()
                } else {
                    ZStack(alignment: .center) {
                        ProgressView(value: progress)
                            .progressViewStyle(CircularProgressViewStyle())
                    }
                    .frame(width: threshold, height: threshold, alignment: .center).fixedSize()
                    .opacity(progress == 0 ? 0 : 1)
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
