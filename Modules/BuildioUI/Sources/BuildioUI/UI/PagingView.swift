//
//  PagingView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 31.10.2021.
//

import Foundation
import SwiftUI
import BuildioLogic

@MainActor
protocol PagingView: BaseView where ModelType: PagingViewModelProtocol, ModelType.ValueType.ItemType: Identifiable {
    associatedtype ValueBody: View
    associatedtype ToolbarBody: View
    associatedtype HeaderBody: View
    
    @ViewBuilder
    func buildItemView(_ item: ModelType.ValueType.ItemType) -> ValueBody
    
    @ViewBuilder
    func additionalToolbarItems() -> ToolbarBody
    
    @ViewBuilder
    func headerBody() -> HeaderBody
    
    func onAppear()
}

extension PagingView {
    @ViewBuilder
    var body: some View {
        RefreshableScrollView(
            refreshing: model.isScrollViewRefreshing,
            loadMore: {
                model.nextPage()
            }, content: {
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
                                .defaultHorizontalPadding()
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
            })
        .onAppear(perform: {
            onAppear()
        })
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    if model.isTopIndicatorRefreshing.wrappedValue {
                        ProgressView()
                        Spacer(minLength: 20)
                    }
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
            Image(.hourglass)
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
    func additionalToolbarItems() -> some View {
        
    }
    
    @ViewBuilder
    func headerBody() -> some View {
        
    }
    
    func onAppear() {
        
    }
}
