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
    @State var selected: String?
    @State private var showNewBuild: Bool = false
    
    init(app: V0AppResponseItemModel? = nil, model: BuildsViewModel? = nil) {
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
            selected = item.slug
        }, content: {
            BuildRowView(model: .constant(item))
        })
    }
    
    @ViewBuilder
    func navigationLinks() -> some View {
        ForEach(model.items) { item in
            navigationBuild(build: item, selection: $selected)
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
            .accentColor(.b_TextBlack)
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
