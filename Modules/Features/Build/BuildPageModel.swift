//
//  BuildPageModel.swift
//  Modules
//
//  Created by Sergii Khliustin on 05.11.2024.
//

import Foundation
import UITypes
import Models
import Dependencies
import API
import Logger
import Components

package final class BuildPageModel: PageModelType {
    @Published private(set) var build: BuildResponseItemModel {
        didSet {
            setupTimer()
        }
    }
    @Published var messageStyle: MessageStyle = .markdown
    private var timer: Task<Void, Never>?

    deinit{
        timer?.cancel()
    }

    package init(dependencies: DependenciesType, build: BuildResponseItemModel) {
        self.build = build
        super.init(dependencies: dependencies)
        if build.status == .running {
            subscribeRunningBuild(id: self.id, build: build) { [weak self] newBuild in
                self?.build = newBuild
            }
        }
    }

    private func setupTimer() {
        if build.status != .running {
            self.timer?.cancel()
            self.timer = nil
        } else if self.timer == nil {
            self.timer = Task { [weak self] in
                while true {
                    do {
                        try await Task.sleep(for: .seconds(1))
                    } catch {
                        self?.timer?.cancel()
                        self?.timer = nil
                        return
                    }
                    self?.objectWillChange.send()
                }
            }
        }
    }

    func onRebuild() {
        guard !isLoading else { return }
        isLoading = true
        Task {
            do {
                try await dependencies.apiFactory.api(BuildsAPI.self).rebuild(build: build)
            } catch {
                onError(error)
            }
            isLoading = false
        }
    }

    func onAbort() {
        dependencies.navigator.show(.abortBuild(build))
    }
}
