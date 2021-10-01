//
//  BaseView.swift
//  Buildio
//
//  Created by severehed on 01.10.2021.
//

import SwiftUI

protocol RefreshableView {
    associatedtype VALUE
    var model: BaseViewModel<VALUE> { get }
    
    func buildBody() -> AnyView
    func buildValueView(_ value: VALUE) -> AnyView
    func buildErrorView(_ error: Error) -> AnyView
    func buildLoadingView() -> AnyView
}

extension RefreshableView {
    func buildBody() -> AnyView {
        if model.isLoading {
            return buildLoadingView()
        } else if let value = model.value {
            return AnyView(buildValueView(value).padding())
        } else if let error = model.error {
            return buildErrorView(error)
        } else {
            fatalError("Something went wrong")
        }
    }
    
    func buildValueView(_ value: VALUE) -> AnyView {
        fatalError("Should override")
    }
    
    func buildErrorView(_ error: Error) -> AnyView {
        AnyView(
            VStack {
                HStack {
                    Spacer()
                    Button("Refresh", action: model.refresh)
                }
                Spacer()
                Text(error.localizedDescription)
                Spacer()
            }.padding()
        )
    }
    
    func buildLoadingView() -> AnyView {
        return AnyView(ProgressView())
    }
}
