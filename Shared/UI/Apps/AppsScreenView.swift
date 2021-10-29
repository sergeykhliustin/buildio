//
//  AppsScreenView.swift
//  Buildio
//
//  Created by severehed on 28.10.2021.
//

import SwiftUI
import Models

struct AppsScreenView: View, PaginatedView {
    @StateObject var model = AppsViewModel()
    @State private var selected: V0AppResponseItemModel?
    
    func buildValueView(_ value: [V0AppResponseItemModel]) -> some View {
        VStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(value, id: \.slug) { item in
                        NavigationLink(tag: item, selection: $selected, destination: {
                            BuildsScreenView(app: item)
                                .navigationTitle(item.title)
                        }, label: {
                            AppRowView(model: item)
                                .onAppear {
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

struct AppsScreenView_Previews: PreviewProvider {
    static var previews: some View {
        AppsScreenView()
    }
}
