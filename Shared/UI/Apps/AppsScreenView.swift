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
    @SceneStorage("AppsScreenView.selected")
    private var selected: String?
    @State private var searchFocused: Bool = false
    
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
                selected = item.slug
            }
        }, content: {
            AppRowView(model: item)
        })
    }
    
    @ViewBuilder
    func navigationLinks() -> some View {
        if completion == nil {
            ForEach(model.items) { item in
                navigationBuilds(app: item, selection: $selected)
            }
        }
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
