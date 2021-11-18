//
//  AppsScreenView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 28.10.2021.
//

import SwiftUI
import Models

struct AppsScreenView: View, PagingView, RoutingView {
    
//    var selected: V0AppResponseItemModel?
    
    private var completion: ((V0AppResponseItemModel) -> Void)?
    
    init(completion: ((V0AppResponseItemModel) -> Void)? = nil) {
        self.completion = completion
    }
    
    @StateObject var model = ViewModelResolver.resolve(AppsViewModel.self)
    @State var selected: String?
    @State var isActive: Bool = false
    
    func buildItemView(_ item: V0AppResponseItemModel) -> some View {
        ListItemWrapper(cornerRadius: 8, action: {
            if let completion = completion {
                completion(item)
            } else {
                //                activeRoute = .buildsScreen(item)
                selected = item.slug
                isActive = true
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
