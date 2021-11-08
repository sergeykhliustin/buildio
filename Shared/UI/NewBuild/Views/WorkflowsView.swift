//
//  BranchesView.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 08.11.2021.
//

import SwiftUI
import Models
import Combine

final class WorkflowsViewModel: BaseViewModel<[String]> {
    let app: V0AppResponseItemModel
    
    init(app: V0AppResponseItemModel) {
        self.app = app
    }
    
    override func fetch(params: Any?) -> AnyPublisher<[String], ErrorResponse> {
        BuildsAPI()
            .buildWorkflowList(appSlug: app.slug)
            .map({ $0.data ?? [] })
            .eraseToAnyPublisher()
    }
}

struct WorkflowsView: BaseView {
    @StateObject var model: WorkflowsViewModel
    @Binding var workflow: String
    
    init(app: V0AppResponseItemModel, workflow: Binding<String>) {
        _model = StateObject(wrappedValue: WorkflowsViewModel(app: app))
        _workflow = workflow
    }
    
    var body: some View {
        BTextField("Select workflow", text: $workflow)
            .modifier(MenuStringsButtonModifier(icon: "flowchart", strings: $model.value, onSelect: { workflow in
                self.workflow = workflow
            }))
            .onReceive(model.$value) { workflows in
                if workflow.isEmpty {
                    workflow = workflows?.first ?? ""
                }
            }
    }
}

struct WorkflowsView_Previews: PreviewProvider {
    static var previews: some View {
        WorkflowsView(app: V0AppResponseItemModel.preview(), workflow: .constant("workflow"))
    }
}
