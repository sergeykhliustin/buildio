//
//  ViewModelsResolver.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 18.11.2021.
//

import Foundation

final class ViewModelResolver {
    private static var viewModels: [String: Any] = [:]
    
    static func start() {
        _ = resolve(BuildsViewModel.self)
        _ = resolve(AppsViewModel.self)
        _ = resolve(ActivitiesViewModel.self)
    }
    
    static func resolve<T: ResolvableViewModel>(_ type: T.Type) -> T {
        let key = String(describing: type)
        if let viewModel = viewModels[key] as? T {
            return viewModel
        } else {
            let viewModel = T()
            viewModels[key] = viewModel
            return viewModel
        }
    }
}
