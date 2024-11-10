//
//  SelectBranchPageModel.swift
//  Modules
//
//  Created by Sergii Khliustin on 07.11.2024.
//

import Foundation
import UITypes
import API
import Models
import Dependencies

package final class SelectBranchPageModel: PageModelType {
    @Published var data: [String] = []
    let app: V0AppResponseItemModel
    private let completion: (String) -> Void
    package init(
        dependencies: DependenciesType,
        app: V0AppResponseItemModel,
        completion: @escaping (String) -> Void
    ) {
        self.app = app
        self.completion = completion
        super.init(dependencies: dependencies)
        refresh()
    }

    func refresh() {
        guard !isLoading else { return }
        isLoading = true
        Task {
            do {
                self.data =
                    try await dependencies.apiFactory
                    .api(ApplicationAPI.self)
                    .branchList(appSlug: app.slug).data ?? []
            } catch {
                onError(error)
            }
            isLoading = false
        }
    }

    func onSelectBranch(_ branch: String) {
        completion(branch)
        dependencies.navigator.dismiss()
    }
}
