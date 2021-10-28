//
//  BuildsScreenView.swift
//  Buildio
//
//  Created by severehed on 01.10.2021.
//

import SwiftUI
import Models

private extension View {
    func buttonStylePlain() -> some View {
        #if os(iOS)
        return self.buttonStyle(.plain)
        #else
        return self
        #endif
    }
}

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
                NavigationLink("", tag: selected, selection: $selected) {
                    BuildScreenView(model: selected)
                }
                .frame(width: 0, height: 0)
            }
            
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(value, id: \.self) { item in
                        NavigationLink {
                            BuildScreenView(model: item)
                        } label: {
                            BuildRowView(model: item).onAppear {
                                if item == value.last {
                                    logger.warning("load more item")
                                    model.nextPage()
                                }
                            }
                            .padding(8)
                            //                            .onTapGesture {
                            //                                logger.debug(item.slug)
                            //                                selected = item
                            //                            }
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

struct BuildsView_Previews: PreviewProvider {
    static var previews: some View {
        BuildsScreenView()
    }
}
