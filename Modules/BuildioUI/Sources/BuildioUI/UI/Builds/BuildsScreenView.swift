//
//  BuildsScreenView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 01.10.2021.
//

import SwiftUI
import Models

struct BuildsScreenView: View, PagingView, RoutingView {
    @StateObject var model: BuildsViewModel
    @State private var showNewBuild: Bool = false
    @State private var selectedBuild: BuildResponseItemModel?
    @State private var selection: String?
    
    init(app: V0AppResponseItemModel? = nil, model: BuildsViewModel? = nil) {
        if let model = model {
            self._model = StateObject(wrappedValue: model)
        }
        if let app = app {
            self._model = StateObject(wrappedValue: BuildsViewModel(app: app))
        } else {
            self._model = StateObject(wrappedValue: ViewModelResolver.resolve(BuildsViewModel.self))
        }
    }
    
    func buildItemView(_ item: BuildResponseItemModel) -> some View {
        ListItemWrapper(action: {
            selectBuild(item)
        }, content: {
            BuildRowView(model: .constant(item))
        })
    }
    
    func selectBuild(_ item: BuildResponseItemModel) {
        selectedBuild = item
        
        // Temp fix for conditional NavigationLink animation
        DispatchQueue.main.async {
            DispatchQueue.main.async {
                selection = item.slug
            }
        }
    }
    
    @ViewBuilder
    func navigationLinks() -> some View {
        if let selectedBuild = selectedBuild {
            navigationBuild(build: selectedBuild, selection: $selection)
        }
    }
    
    @ViewBuilder
    func additionalToolbarItems() -> some View {
        Button {
            showNewBuild.toggle()
        } label: {
            Image(systemName: "plus")
        }
        .sheet(isPresented: $showNewBuild) {
            model.refresh()
        } content: {
            NavigationView {
                NewBuildScreenView(app: model.app)
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
        return BuildsScreenView(model: model)
    }
}
