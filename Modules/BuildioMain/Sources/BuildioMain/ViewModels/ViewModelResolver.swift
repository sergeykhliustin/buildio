//
//  ViewModelsResolver.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 18.11.2021.
//

import Foundation
import Models
import Combine

final class ViewModelResolver {
    private typealias CacheValue = (Date, TimeInterval, CacheableViewModel)
    private static var viewModels: [String: Any] = [:]
    private static var cachedViewModels: [String: CacheValue] = [:]
    private static var tokenHandler: AnyCancellable?
    
    static func start() {
        _ = resolve(BuildsViewModel.self)
        _ = resolve(AppsViewModel.self)
        _ = resolve(ActivitiesViewModel.self)
        
        tokenHandler = TokenManager.shared.$token
            .dropFirst()
            .sink(receiveValue: { _ in
                cleanupCache()
            })
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
    
    static func build(_ build: BuildResponseItemModel) -> BuildViewModel {
        let model = cached(key: "BuildViewModel_\(build.slug)", ttl: Double.greatestFiniteMagnitude, model: BuildViewModel(build: build))
        if build.status != .running {
            model.value = build
        }
        return model
    }
    
    static func cached<T: CacheableViewModel>(key: String, ttl: TimeInterval, model: @autoclosure () -> T) -> T {
        DispatchQueue.main.async {
            cleanupCache()
        }
        let modelKey = String(describing: T.self) + key
        if let value = cachedViewModels[modelKey], value.0.distance(to: Date()) < ttl, let modelValue = value.2 as? T {
            cachedViewModels[modelKey] = (Date(), ttl, modelValue)
            return modelValue
        } else {
            let modelValue = model()
            cachedViewModels[modelKey] = (Date(), ttl, modelValue)
            return modelValue
        }
    }
    
    private static func cleanupCache() {
        cachedViewModels = cachedViewModels.reduce([String: CacheValue]()) { partialResult, value in
            var result = partialResult
            if value.value.0.distance(to: Date()) < value.value.1 {
                result[value.key] = value.value
            }
            return result
        }
    }
}
