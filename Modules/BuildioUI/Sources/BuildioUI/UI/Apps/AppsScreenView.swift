//
//  AppsScreenView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 28.10.2021.
//

import SwiftUI
import Models

struct AppsScreenView: View, PagingView, RoutingView {
    
    private var completion: ((V0AppResponseItemModel) -> Void)?
    
    init(completion: ((V0AppResponseItemModel) -> Void)? = nil) {
        self.completion = completion
    }
    
    @StateObject var model = ViewModelResolver.resolve(AppsViewModel.self)
    @State private var selection: V0AppResponseItemModel?
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
            .foregroundColor(.b_TextBlack)
            .frame(height: 44)
            .modifier(ClearButton(text: text))
            .modifier(RoundedBorderShadowModifier(borderColor: searchFocused ? .b_Primary : .b_BorderLight, horizontalPadding: 8))
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
