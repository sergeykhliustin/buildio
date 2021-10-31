//
//  PagingView.swift
//  Buildio
//
//  Created by severehed on 31.10.2021.
//

import Foundation
import SwiftUI

protocol PagingView: BaseView where ModelType: PagingViewModelProtocol, ModelType.ValueType.ItemType: Hashable {
    associatedtype ValueBody: View
    var selected: ModelType.ValueType.ItemType? { get }
    
    @ViewBuilder
    func buildItemView(_ item: ModelType.ValueType.ItemType) -> ValueBody
}

extension PagingView {
    @ViewBuilder
    var body: some View {
        VStack {
            ScrollView {
                if case .loading = model.state {
                    ProgressView()
                        .padding(16)
                } else if case .error(let error) = model.state {
                    buildErrorView(error)
                }
                LazyVStack(spacing: 16) {
                    ForEach(model.items, id: \.self) { item in
                        buildItemView(item)
                    }
                }
                if case .loading = model.pagingState {
                    ProgressView()
                        .padding(16)
                } else if case .error(let error) = model.pagingState {
                    buildErrorView(error)
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
    
    @ViewBuilder
    func buildErrorView(_ error: ErrorResponse) -> some View {
        Text(error.rawError.localizedDescription)
            .padding(16)
    }
}
