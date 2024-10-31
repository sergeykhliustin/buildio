//
//  SelectStringScreenView.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 09.11.2021.
//

import SwiftUI

struct SelectStringScreenView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    private let strings: [String]
    private let onSelect: (String) -> Void
    init(_ strings: [String], onSelect: @escaping (String) -> Void) {
        self.strings = strings
        self.onSelect = onSelect
    }
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 8) {
                ForEach(strings, id: \.self) { string in
                    ListItemWrapper {
                        onSelect(string)
                        presentationMode.wrappedValue.dismiss()
                    } content: {
                        Text(string)
                            .frame(maxWidth: .infinity, minHeight: 22, alignment: .leading)
                            .padding(8)
                            
                    }
                }
            }
            .padding(.vertical, 8)
            .defaultHorizontalPadding()
        }
        .font(.footnote)
    }
}

struct SelectStringScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SelectStringScreenView(["branch1", "branch2", "branch3", "branch4", "branch5"], onSelect: { _ in})
    }
}
