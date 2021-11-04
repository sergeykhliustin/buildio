//
//  BuildsScreenView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 01.10.2021.
//

import SwiftUI
import Models

struct BuildsScreenView: View, PagingView, AppMultiRouteView {
    let router: AppRouter
    @State var activeRoute: AppRoute?
    
    @StateObject var model: BuildsViewModel
    @State var selected: BuildResponseItemModel?
    @State private var showNewBuild: Bool = false
    
    init(router: AppRouter = AppRouter(), app: V0AppResponseItemModel? = nil, model: BuildsViewModel? = nil) {
        self.router = router
        if let model = model {
            self._model = StateObject(wrappedValue: model)
        }
        if let app = app {
            self._model = StateObject(wrappedValue: BuildsViewModel(app: app))
        } else {
            self._model = StateObject(wrappedValue: BuildsViewModel())
        }
    }
    
    func buildItemView(_ item: BuildResponseItemModel) -> some View {
        ZStack {
            router.navigationLink(route: .buildScreen(item), selection: $activeRoute)
            
            ListItemWrapper { highlighted in
                BuildRowView(model: .constant(item)).onAppear {
                    if item == model.items.last {
                        logger.debug("UI load more builds")
                        model.nextPage()
                    }
                }
                .multiplatformButtonStylePlain()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .border(highlighted ? Color.b_ButtonPrimary : Color.clear)
            } action: {
                activeRoute = .buildScreen(item)
            }
            .padding(.horizontal, 16)
        }
    }
    
    @ViewBuilder
    func additionalToolbarItems() -> some View {
        Button {
            showNewBuild.toggle()
        } label: {
            Image(systemName: "plus.app")
        }
        .frame(width: 44, height: 44, alignment: .center)
        .sheet(isPresented: $showNewBuild) {
            model.refresh()
        } content: {
            NewBuildScreenView()
        }

    }
}

struct BuildsView_Previews: PreviewProvider {
    static var previews: some View {
        let model = BuildsViewModel()
        model.items = [BuildResponseItemModel.preview()]
        model.state = .value
        return BuildsScreenView(router: AppRouter(), model: model)
    }
}
