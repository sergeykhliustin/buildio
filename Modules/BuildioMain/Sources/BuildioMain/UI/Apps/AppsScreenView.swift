//
//  AppsScreenView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 28.10.2021.
//

import SwiftUI
import Models

struct AppsScreenView: View, PagingView, RoutingView {
    @Environment(\.colorScheme.theme) var theme
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
        TextField("Search",
                  text: text,
                  onEditingChanged: { editing in
            self.searchFocused = editing
        })
            .font(.callout)
            .frame(height: 44)
            .modifier(ClearButton(text: text))
            .modifier(RoundedBorderShadowModifier(borderColor: searchFocused ? theme.accentColor : theme.borderColor, horizontalPadding: 8))
            .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    func buildItemView(_ item: V0AppResponseItemModel) -> some View {
        ListItemWrapper(cornerRadius: 8, action: {
            if let completion = completion {
                completion(item)
            } else {
                route = .builds(item)
            }
        }, content: {
            AppRowView(model: item)
        })
    }
    
    @ViewBuilder
    func navigationLinks() -> some View {
        navigationLinks(route: $route)
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
