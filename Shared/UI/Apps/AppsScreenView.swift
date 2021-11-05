//
//  AppsScreenView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 28.10.2021.
//

import SwiftUI
import Models

struct AppsScreenView: View, PagingView, AppMultiRouteView {
    let router: AppRouter
    @State var activeRoute: AppRoute?
    
    init(router: AppRouter = AppRouter()) {
        self.router = router
    }
    
    @StateObject var model = AppsViewModel()
    @State var selected: V0AppResponseItemModel?
    
    func buildItemView(_ item: V0AppResponseItemModel) -> some View {
        ListItemWrapper(cornerRadius: 8, action: {
            activeRoute = .buildsScreen(item)
        }, content: {
            AppRowView(model: item)
        })
            .padding(.horizontal, 16)
        
        router.navigationLink(route: .buildsScreen(item), selection: $activeRoute)
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
