//
//  BaseView.swift
//  Buildio
//
//  Created by severehed on 01.10.2021.
//

import SwiftUI

protocol BaseView: View {
    associatedtype MODEL: BaseViewModel
    var model: MODEL { get }
    
    associatedtype ValueBody: View
//    associatedtype LoadingBody: View
//    associatedtype ErrorBody: View
    
    func buildValueView(_ value: MODEL.VALUE) -> ValueBody
}

protocol PaginatedView: BaseView {
    
}

extension BaseView {
    
    @ViewBuilder
    var body: some View {
        buildBody()
    }
    
    @ViewBuilder
    func buildBody() -> some View {
        switch model.state {
        case .loading, .idle:
            buildLoadingView()
        case .value(let value):
            buildValueView(value)
        case .error(let error):
            buildErrorView(error)
        }
    }
    
    @ViewBuilder
    func buildErrorView(_ error: Error?) -> some View {
        VStack {
            HStack {
                Spacer()
                Button("Refresh", action: model.refresh)
            }.padding()
            Spacer()
            Text(error?.localizedDescription ?? "Unknown error")
            Spacer()
        }.padding()
        
    }
    
    @ViewBuilder
    func buildLoadingView() -> some View {
        VStack {
            HStack {
                ProgressView()
            }
        }
    }
}
