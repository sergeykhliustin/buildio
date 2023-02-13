//
//  RefreshableScrollView.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 22.11.2021.
//

import SwiftUI

private struct OffsetReader: View {
    var onChange: (CGRect) -> Void
    @State private var frame = CGRect()

    public var body: some View {
        GeometryReader { geometry in
            Spacer(minLength: 0)
                .onChange(of: geometry.frame(in: .global)) { value in
                    if value.integral != self.frame.integral {
                        DispatchQueue.main.async {
                            self.frame = value
                            onChange(value)
                        }
                    }
                }
        }
    }
}

struct RefreshableScrollView<Content: View>: View {
    @Environment(\.theme) private var theme
    @State private var previousScrollOffset: CGFloat = 0
    @State private var progress: CGFloat = 0

    private let axes: Axis.Set
    private var threshold: CGFloat
    private let loadMoreThreshold: CGFloat = 60
    @Binding private var refreshing: Bool
    @ViewBuilder private let content: () -> Content
    @State private var globalInset = CGRect.zero
    private var loadMore: (() -> Void)?

    init(_ axes: Axis.Set = .vertical,
         height: CGFloat = 60,
         refreshing: Binding<Bool>,
         loadMore: (() -> Void)? = nil,
         @ViewBuilder content: @escaping () -> Content) {
        self.axes = axes
        self.threshold = height
        self._refreshing = refreshing
        self.loadMore = loadMore
        self.content = content

    }
    
    var body: some View {
        GeometryReader { globalGeometry in
            ScrollView(axes) {
                ZStack(alignment: .top) {
                    OffsetReader { val in
                        offsetChanged(val)
                    }
                    SymbolView(threshold: self.threshold,
                               loading: self.refreshing,
                               progress: self.progress)
                    VStack(spacing: 0) {
                        self.content()
                            .offset(x: 0, y: threshold * progress)
                    }
                }
            }
            .onChange(of: globalGeometry.frame(in: .global)) { newValue in
                globalInset = newValue
            }
            .onAppear {
                DispatchQueue.main.async {
                    globalInset = globalGeometry.frame(in: .global)
                }
            }
        }
    }

    private func offsetChanged(_ val: CGRect) {
        guard globalInset != .zero else { return }
        let scrollOffset = val.minY - globalInset.minY

        self.progress = symbolProgress(scrollOffset)

        // Crossing the threshold on the way down, we start the refresh process
        if !self.refreshing && (scrollOffset > self.threshold && self.previousScrollOffset <= self.threshold) {
            self.refreshing = true
        } else if (val.maxY - loadMoreThreshold) <= globalInset.maxY {
            loadMore?()
        }

        // Update last scroll offset
        self.previousScrollOffset = scrollOffset
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
                    .frame(width: threshold, height: threshold + 16, alignment: .center) // 16 is default top padding for all views
                    .opacity(progress < 0.2 ? 0 : 1)
                }
            }
        }
    }
}
