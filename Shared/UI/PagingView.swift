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
//    var selected: ModelType.ValueType.ItemType? { get }
    
    @ViewBuilder
    func buildItemView(_ item: ModelType.ValueType.ItemType) -> ValueBody
    
    @ViewBuilder
    func additionalToolbarItems() -> ToolbarBody
    
    @ViewBuilder
    func navigationLinks() -> NavigationLinksBody
    
    @ViewBuilder
    func headerBody() -> HeaderBody
}

extension PagingView {
    @ViewBuilder
    var body: some View {
        VStack(spacing: 0) {
            navigationLinks()
            RefreshableScrollView(refreshing: model.isRefreshing) {
                if let error = model.error, model.state == .error {
                    buildErrorView(error)
                } else {
                    
                }
                LazyVStack(spacing: 16, pinnedViews: [.sectionHeaders]) {
                    Section {
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
                            .padding(.top, 8)
                            .frame(height: 44)
                    }
                }
                .padding(.bottom, 16)
                if case .loading = model.pagingState {
                    CustomProgressView()
                        .padding(.bottom, 16)
                } else if case .error(let error) = model.pagingState {
                    buildErrorView(error)
                }
            }
        }
        .toolbar {
            HStack(alignment: .center, spacing: 0) {
                additionalToolbarItems()
            }
        }
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
}
