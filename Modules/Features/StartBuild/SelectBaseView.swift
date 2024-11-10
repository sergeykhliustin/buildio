//
//  SelectBaseView.swift
//  Modules
//
//  Created by Sergii Khliustin on 07.11.2024.
//

import Foundation
import SwiftUI
import Components

struct SelectBaseView: View {
    let data: [String]
    let onRefresh: () -> Void
    let onSelect: (String) -> Void

    var body: some View {
        BuildioList {
            ForEach(data, id: \.self) { item in
                ListItem(
                    action: { onSelect(item) },
                    content: {
                        Text(item)
                            .frame(maxWidth: .infinity, minHeight: 22, alignment: .leading)
                            .padding(8)
                            .font(.footnote)
                    }
                )
            }
        }
        .refreshable {
            onRefresh()
        }
    }
}

#Preview {
    SelectBaseView(
        data: [
            "Item 1",
            "Item 2",
            "Item 3",
            "Item 4",
            "Item 5\nwith a very long text"
        ],
        onRefresh: {},
        onSelect: { _ in }
    )
}
