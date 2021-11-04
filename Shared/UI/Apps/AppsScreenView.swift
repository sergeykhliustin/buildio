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
        Button {
            activeRoute = .buildsScreen(item)
        } label: {
            AppRowView(model: item)
                .onAppear {
                    if item == model.items.last {
                        logger.warning("load more item")
                        model.nextPage()
                    }
                }
                .multiplatformButtonStylePlain()
        }
        
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
