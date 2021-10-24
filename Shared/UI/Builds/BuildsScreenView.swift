//
//  BuildsScreenView.swift
//  Buildio
//
//  Created by severehed on 01.10.2021.
//

import SwiftUI
import Models

struct BuildsScreenView: View, BaseView {
    @StateObject var model = BuildsViewModel()
    
    func buildValueView(_ value: [V0BuildListAllResponseItemModel]) -> some View {
        VStack {
            HStack {
                Spacer()
                Button("Refresh", action: model.refresh)
            }
            ScrollView {
                LazyVStack {
                    ForEach(value, id: \.self) { item in
                        BuildRowView(model: item).onAppear {
                            if item == value.last {
                                logger.warning("load more item")
                                model.loadNextPage()
                            }
                        }
                    }
                }
                if model.isLoadingPage {
                    ProgressView()
                }
            }
        }
    }
}

struct BuildsView_Previews: PreviewProvider {
    static var previews: some View {
        BuildsScreenView()
    }
}
