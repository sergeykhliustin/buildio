//
//  CustomViewContainer.swift
//  Modules
//
//  Created by Sergii Khliustin on 08.11.2024.
//

import Foundation
import SwiftUI

package struct BuildioTabView<Selection: Hashable & Identifiable, Content: View>: View {
    let tabs: [Selection]
    @Binding var tab: Selection
    let content: (Selection) -> Content

    package init(tabs: [Selection], tab: Binding<Selection>, @ViewBuilder content: @escaping (Selection) -> Content) {
        self.tabs = tabs
        self._tab = tab
        self.content = content
    }

    package var body: some View {
        ZStack {
            ForEach(tabs) { tab in
                content(tab)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .opacity(self.tab.id == tab.id ? 1 : 0)
            }
        }
    }
}

private extension View {
    @ViewBuilder
    func hidden(_ hidden: Bool) -> some View {
        if hidden {
            self.hidden()
        } else {
            self
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    @Previewable @State var selection: Int = 0

    VStack {
        BuildioTabView(tabs: Array(0..<5), tab: $selection) { tab in
            Text("Tab \(tab)")
        }
        HStack {
            ForEach(0..<5) { index in
                Button(
                    action: { selection = index },
                    label: {
                        Text("Tab \(index)")
                    }
                )
            }
        }
    }
}

extension Int: Identifiable {
    public var id: Int {
        self
    }
}
