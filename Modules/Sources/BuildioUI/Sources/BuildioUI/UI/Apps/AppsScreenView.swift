//
//  AppsScreenView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 28.10.2021.
//

import SwiftUI
import Models
import BuildioLogic

struct AppsScreenView: View, PagingView {
    @EnvironmentObject private var navigator: Navigator
    @Environment(\.theme) private var theme
    @EnvironmentObject var model: AppsViewModel
    
    private var completion: ((V0AppResponseItemModel) -> Void)?
    
    init(completion: ((V0AppResponseItemModel) -> Void)? = nil) {
        self.completion = completion
    }

    @State private var searchFocused: Bool = false
    @State private var route: Route?
    
    @ViewBuilder
    func headerBody() -> some View {
        let text = Binding(get: { model.searchText }, set: { model.searchText = $0 })
        TextField("",
                  text: text,
                  onEditingChanged: { editing in
            self.searchFocused = editing
        })
        .font(.callout)
        .frame(height: 44)
        .modifier(PlaceholderTextField(placeholder: "Search", text: text))
        .modifier(ClearButton(text: text))
        .modifier(RoundedBorderShadowModifier(focused: searchFocused, horizontalPadding: 8))
        .background(theme.background)
        .padding(.horizontal, 16)
        .foregroundColor(theme.textColor)
    }
    
    @ViewBuilder
    func buildItemView(_ item: V0AppResponseItemModel) -> some View {
        ListItemWrapper(cornerRadius: 8, action: {
            if let completion = completion {
                completion(item)
            } else {
                navigator.go(.builds(item), replace: true)
            }
        }, content: {
            AppRowView(model: item)
        })
    }
    
    @ViewBuilder
    func additionalToolbarItems() -> some View {
        
    }
}

struct AppsScreenView_Previews: PreviewProvider {
    static var previews: some View {
        AppsScreenView()
    }
}
