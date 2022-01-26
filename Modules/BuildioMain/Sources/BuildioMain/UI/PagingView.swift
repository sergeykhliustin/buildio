//
//  PagingView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 31.10.2021.
//

import Foundation
import SwiftUI

protocol PagingView: BaseView where ModelType: PagingViewModelProtocol, ModelType.ValueType.ItemType: Hashable {
    associatedtype ValueBody: View
    associatedtype ToolbarBody: View
    associatedtype NavigationLinksBody: View
    associatedtype HeaderBody: View
    
    @ViewBuilder
    func buildItemView(_ item: ModelType.ValueType.ItemType) -> ValueBody
    
    @ViewBuilder
    func additionalToolbarItems() -> ToolbarBody
    
    @ViewBuilder
    func navigationLinks() -> NavigationLinksBody
    
    @ViewBuilder
    func headerBody() -> HeaderBody
    
    func onAppear()
}

extension PagingView {
    @ViewBuilder
    var body: some View {
        RefreshableScrollView(refreshing: model.isScrollViewRefreshing) {
            ZStack {
                navigationLinks()
            }
            .frame(width: 0, height: 0)
            if let error = model.error, model.state == .error {
                buildErrorView(error)
            }
            LazyVStack(spacing: 16, pinnedViews: [.sectionHeaders]) {
                Section {
                    if model.items.isEmpty && model.state == .value {
                        buildEmptyView()
                    }
                    ForEach(model.items) { item in
                        buildItemView(item)
                            .onAppear {
                                if item == model.items.last {
                                    logger.debug("UI load more builds")
                                    model.nextPage()
                                }
                            }
                    }
                } header: {
                    headerBody()
                        .frame(height: 44)
                }
            }
            .padding(.vertical, 16)
            if case .loading = model.pagingState {
                ProgressView()
                    .padding(.bottom, 16)
            } else if case .error(let error) = model.pagingState {
                buildErrorView(error)
            }
        }
        .onAppear(perform: {
            onAppear()
        })
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if model.isTopIndicatorRefreshing.wrappedValue {
                    ProgressView()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                additionalToolbarItems()
            }
        }
    }
    
    @ViewBuilder
    func buildEmptyView() -> some View {
        VStack(spacing: 16) {
            Image(systemName: "hourglass")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40, alignment: .center)
            Text("Nothing to show")
        }
        .padding(16)
    }
    
    @ViewBuilder
    func buildErrorView(_ error: ErrorResponse) -> some View {
        Text(error.rawErrorString)
            .padding(16)
    }
    
    @ViewBuilder
    func navigationLinks() -> some View {
        
    }
    
    @ViewBuilder
    func additionalToolbarItems() -> some View {
        
    }
    
    @ViewBuilder
    func headerBody() -> some View {
        
    }
    
    func onAppear() {
        
    }
}
