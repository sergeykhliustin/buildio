//
//  BuildioList.swift
//  Modules
//
//  Created by Sergii Khliustin on 06.11.2024.
//

import Foundation
import SwiftUI

package struct BuildioList<Content: View>: View {
    private let content: () -> Content

    package init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    package var body: some View {
        List {
            Group {
                content()
            }
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listSectionSeparator(.hidden)
            .listSectionSeparatorTint(.clear)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    BuildioList {
        ForEach(0..<10) { index in
            Text("Row \(index)")
                .padding()
                .background(Color.red)
        }
    }
}
