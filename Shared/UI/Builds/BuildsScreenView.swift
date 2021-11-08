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
    @State var isRouteActive: Bool = false
    
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
        ListItemWrapper(action: {
            activeRoute = .buildScreen(item)
        }, content: {
            BuildRowView(model: .constant(item))
        })
    }
    
    @ViewBuilder
    func navigationLinks() -> some View {
        ForEach(model.items) { item in
            router.navigationLink(route: .buildScreen(item), selection: $activeRoute)
                .hidden()
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
            NavigationView {
                NewBuildScreenView()
                    .navigationTitle("Start a build")
            }
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
