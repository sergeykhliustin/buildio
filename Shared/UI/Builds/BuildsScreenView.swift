//
//  BuildsScreenView.swift
//  Buildio
//
//  Created by severehed on 01.10.2021.
//

import SwiftUI
import Models

struct BuildsScreenView: View, BaseView {
    @StateObject var model: BuildsViewModel
    @State private var selected: V0BuildListAllResponseItemModel?
    @State private var isActive: Bool = false
    
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
    
    func buildValueView(_ value: [V0BuildListAllResponseItemModel]) -> some View {
        VStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(value, id: \.self) { item in
                        NavigationLink(tag: item, selection: $selected, destination: {
                            BuildScreenView(model: item)
                        }, label: {
                            BuildRowView(model: item).onAppear {
                                if item == value.last {
                                    logger.warning("load more item")
                                    model.nextPage()
                                }
                            }
                            .multiplatformButtonStylePlain()
                        })
                        
                    }
                }
                if model.isLoadingPage {
                    ProgressView()
                }
            }
        }
        .toolbar {
            Button {
                model.refresh()
            } label: {
                Image(systemName: "arrow.counterclockwise")
            }
            .frame(width: 44, height: 44, alignment: .center)
        }
    }
}

struct BuildsView_Previews: PreviewProvider {
    static var previews: some View {
        let model = BuildsViewModel()
        model.state = .value([V0BuildListAllResponseItemModel.preview()])
        return BuildsScreenView(model: model)
    }
}
