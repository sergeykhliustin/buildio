//
//  BaseView.swift
//  Buildio
//
//  Created by severehed on 01.10.2021.
//

import SwiftUI

protocol RefreshableView: View {
    associatedtype VALUE
    var model: BaseViewModel<VALUE> { get }
    
    associatedtype ValueBody: View
    associatedtype LoadingBody: View
    associatedtype ErrorBody: View
    
    func buildValueView(_ value: VALUE) -> ValueBody
    func buildErrorView(_ error: Error) -> ErrorBody
    func buildLoadingView() -> LoadingBody
}

extension RefreshableView {
    
    @ViewBuilder
    var body: some View {
        buildBody()
    }
    
    @ViewBuilder
    func buildBody() -> some View {
        if model.isLoading {
            self.buildLoadingView()
        } else if let value = model.value {
            buildValueView(value)
        } else if let error = model.error {
            buildErrorView(error)
        } else {
            fatalError("Something went wrong")
        }
    }
    
    @ViewBuilder
    func buildErrorView(_ error: Error) -> some View {
        VStack {
            HStack {
                Spacer()
                Button("Refresh", action: model.refresh)
            }.padding()
            Spacer()
            Text(error.localizedDescription)
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
