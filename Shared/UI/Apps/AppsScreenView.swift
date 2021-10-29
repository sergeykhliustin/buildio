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
            if let selected = selected {
                NavigationLink("", tag: selected, selection: $selected) {
                
                }
                .frame(width: 0, height: 0)
            }
            
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(value, id: \.slug) { item in
                        NavigationLink {
                            
                        } label: {
                            AppRowView(model: item)
                                .onAppear {
                                    if item == value.last {
                                        logger.warning("load more item")
                                        model.nextPage()
                                    }
                                }
                                .padding(8)
                        }
                        .isDetailLink(true)
                        .buttonStylePlain()
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
