//
//  AppsScreenView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 28.10.2021.
//

import SwiftUI
import Models

struct AppsScreenView: View, PagingView {
    @StateObject var model = AppsViewModel()
    @State var selected: V0AppResponseItemModel?
    
    func buildItemView(_ item: V0AppResponseItemModel) -> some View {
        NavigationLink(tag: item, selection: $selected, destination: {
            BuildsScreenView(app: item)
                .navigationTitle(item.title)
        }, label: {
            AppRowView(model: item)
                .onAppear {
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
        
    }
}

struct AppsScreenView_Previews: PreviewProvider {
    static var previews: some View {
        AppsScreenView()
    }
}
