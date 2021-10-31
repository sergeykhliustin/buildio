//
//  BuildsScreenView.swift
//  Buildio
//
//  Created by severehed on 01.10.2021.
//

import SwiftUI
import Models

struct BuildsScreenView: View, PagingView {
    @StateObject var model: BuildsViewModel
    @State var selected: V0BuildResponseItemModel?
    
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
            BuildScreenView(model: item)
        }, label: {
            BuildRowView(model: item).onAppear {
                if item == model.items.last {
                    logger.warning("load more item")
                    model.nextPage()
                }
            }
            .multiplatformButtonStylePlain()
        })
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
