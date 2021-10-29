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
    @State private var selected: V0BuildListAllResponseItemModel?
    
    func buildValueView(_ value: [V0BuildListAllResponseItemModel]) -> some View {
        
        VStack {
            //                HStack {
            //                    Spacer()
            //                    Button("Refresh", action: model.refresh)
            //                }
            
            if let selected = selected {
                NavigationLink(multiplatformDestination: {
                    BuildScreenView(model: selected)
                }, tag: selected, selection: $selected)
                    .frame(width: 0, height: 0)
            }
            
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(value, id: \.self) { item in
                        NavigationLink(multiplatformDestination: {
                            BuildScreenView(model: item)
                        }, label: {
                            BuildRowView(model: item).onAppear {
                                if item == value.last {
                                    logger.warning("load more item")
                                    model.nextPage()
                                }
                            }
                            .padding(8)
                        })
                        .multiplatformButtonStylePlain()
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
        BuildsScreenView()
    }
}
