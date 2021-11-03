//
//  BuildsScreenView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 01.10.2021.
//

import SwiftUI
import Models

struct BuildsScreenView: View, PagingView {
    @StateObject var model: BuildsViewModel
    @State var selected: V0BuildResponseItemModel?
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
    
    func buildItemView(_ item: V0BuildResponseItemModel) -> some View {
        NavigationLink(tag: item, selection: $selected, destination: {
            BuildScreenView(build: item)
        }, label: {
            BuildRowView(model: .constant(item)).onAppear {
                if item == model.items.last {
                    logger.warning("load more item")
                    model.nextPage()
                }
            }
            .multiplatformButtonStylePlain()
        })
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
        model.items = [V0BuildResponseItemModel.preview()]
        model.state = .value
        return BuildsScreenView(model: model)
    }
}
