//
//  ViewModelsResolver.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 18.11.2021.
//

import Foundation
import Models
import Combine

@MainActor
public final class ViewModelFactory {
    private typealias CacheValue = (Date, TimeInterval, CacheableViewModel)
    
    private let tokenManager: TokenManager
    
    private var viewModels: [String: Any] = [:]
    private var cachedViewModels: [String: CacheValue] = [:]
    private var tokenHandler: AnyCancellable?
    
    private var isDemo: Bool = false {
        willSet {
            if newValue != isDemo {
                viewModels.removeAll()
            }
        }
    }
    
    public init(_ tokenManager: TokenManager) {
        self.tokenManager = tokenManager
        tokenHandler = tokenManager.$token
            .sink(receiveValue: { value in
                self.cleanupCache()
                if let value = value {
                    self.isDemo = value.isDemo
                }
                if value != nil {
                    self.resolveRootModels()
                }
            })
    }
    
    private func resolveRootModels() {
        _ = resolve(BuildsViewModel.self)
        _ = resolve(AppsViewModel.self)
    }
    
    public func resolve<T: RootViewModel>(_ type: T.Type) -> T {
        let key = String(describing: type)
        if let viewModel = viewModels[key] as? T {
            return viewModel
        } else {
            let viewModel = T(tokenManager)
            viewModels[key] = viewModel
            return viewModel
        }
    }
    
    public func builds(app: V0AppResponseItemModel?) -> BuildsViewModel {
        return app == nil ? resolve(BuildsViewModel.self) : BuildsViewModel(tokenManager, app: app)
    }
    
    public func build(_ build: BuildResponseItemModel) -> BuildViewModel {
        let model = cached(key: "BuildViewModel_\(build.slug)", model: BuildViewModel(tokenManager, build: build))
        if build.status != .running {
            model.value = build
        }
        return model
    }
    
    public func logs(_ build: BuildResponseItemModel) -> LogsViewModel {
        LogsViewModel(tokenManager, build: build)
    }
    
    public func artifacts(_ build: BuildResponseItemModel) -> ArtifactsViewModel {
        ArtifactsViewModel(tokenManager, build: build)
    }
    
    public func yml(_ build: BuildResponseItemModel) -> BuildYmlViewModel {
        BuildYmlViewModel(tokenManager, build: build)
    }

    public func accountSettings(_ token: Token) -> AccountSettingsViewModel {
        AccountSettingsViewModel(token: token)
    }
    
    public func newBuild() -> NewBuildViewModel {
        NewBuildViewModel(tokenManager)
    }
    
    public func branches(app: V0AppResponseItemModel) -> BranchesViewModel {
        BranchesViewModel(tokenManager, app: app)
    }
    
    public func workflows(app: V0AppResponseItemModel) -> WorkflowsViewModel {
        WorkflowsViewModel(tokenManager, app: app)
    }
    
    public func avatar(app: V0AppResponseItemModel) -> AvatarViewModel {
        let key = "AvatartViewModel_" + app.title + (app.avatarUrl ?? "")
        return cached(key: key, model: AvatarViewModel(title: app.title, url: app.avatarUrl))
    }
    
    public func avatar(user: V0UserProfileDataModel) -> AvatarViewModel {
        let key = "AvatartViewModel_" + (user.username ?? user.email) + (user.avatarUrl ?? "")
        return cached(key: key, model: AvatarViewModel(title: user.username ?? user.email, url: user.avatarUrl))
    }
    
    public func avatar(title: String? = nil, url: String? = nil) -> AvatarViewModel {
        AvatarViewModel(title: title, url: url)
    }
    
    func cached<T: CacheableViewModel>(key: String, ttl: TimeInterval = Double.greatestFiniteMagnitude, model: @autoclosure () -> T) -> T {
        DispatchQueue.main.async {
            self.cleanupCache()
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
    
    private func cleanupCache() {
        cachedViewModels = cachedViewModels.reduce([String: CacheValue]()) { partialResult, value in
            var result = partialResult
            if value.value.0.distance(to: Date()) < value.value.1 {
                result[value.key] = value.value
            }
            return result
        }
    }
}
