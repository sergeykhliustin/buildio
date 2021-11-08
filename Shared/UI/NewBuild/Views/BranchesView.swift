//
//  BranchesView.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 08.11.2021.
//

import SwiftUI
import Models
import Combine

final class BranchesViewModel: BaseViewModel<[String]> {
    let app: V0AppResponseItemModel
    
    init(app: V0AppResponseItemModel) {
        self.app = app
    }
    
    override func fetch(params: Any?) -> AnyPublisher<[String], ErrorResponse> {
        ApplicationAPI()
            .branchList(appSlug: app.slug)
            .map({ $0.data ?? [] })
            .eraseToAnyPublisher()
    }
}

struct BranchesView: BaseView {
    @StateObject var model: BranchesViewModel
    @Binding var branch: String
    
    init(app: V0AppResponseItemModel, branch: Binding<String>) {
        _model = StateObject(wrappedValue: BranchesViewModel(app: app))
        _branch = branch
    }
    
    var body: some View {
        BTextField("Select branch", text: $branch)
            .modifier(MenuStringsButtonModifier(icon: "arrow.triangle.branch", strings: $model.value, onSelect: { branch in
                self.branch = branch
            }))
            .onReceive(model.$value) { branches in
                if branch.isEmpty {
                    branch = branches?.first ?? ""
                }
            }
    }
}

struct BranchesView_Previews: PreviewProvider {
    static var previews: some View {
        BranchesView(app: V0AppResponseItemModel.preview(), branch: .constant("branch"))
    }
}
