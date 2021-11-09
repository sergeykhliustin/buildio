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
    @Binding var app: V0AppResponseItemModel
    
    init(app: Binding<V0AppResponseItemModel>) {
        _app = app
    }
    
    override func fetch(params: Any?) -> AnyPublisher<[String], ErrorResponse> {
        BuildsAPI()
            .buildWorkflowList(appSlug: app.slug)
            .map({ $0.data ?? [] })
            .eraseToAnyPublisher()
    }
}

struct WorkflowsView: BaseView, OneRouteView {
    let router: AppRouter
    @State var isActiveRoute: Bool = false
    
    @StateObject var model: WorkflowsViewModel
    @Binding var workflow: String
    @Binding var app: V0AppResponseItemModel
    
    init(router: AppRouter = AppRouter(), app: Binding<V0AppResponseItemModel>, workflow: Binding<String>) {
        _app = app
        _model = StateObject(wrappedValue: WorkflowsViewModel(app: app))
        _workflow = workflow
        self.router = router
    }
    
    var body: some View {
        BTextField("Select workflow", text: $workflow)
            .modifier(RightButtonModifier(icon: "chevron.right", loading: model.value == nil, action: {
                isActiveRoute.toggle()
            }))
            .onReceive(model.$value) { workflows in
                if workflow.isEmpty {
                    workflow = workflows?.first ?? ""
                }
            }
            .onChange(of: app) { newValue in
                workflow = ""
                model.refresh()
            }
        
        NavigationLink(isActive: $isActiveRoute) {
            SelectStringScreenView(model.value ?? []) { workflow in
                self.workflow = workflow
            }
            .navigationTitle("Select workflow:")
        } label: {
            EmptyView()
        }
        .hidden()        
    }
}

struct WorkflowsView_Previews: PreviewProvider {
    static var previews: some View {
        WorkflowsView(app: .constant(V0AppResponseItemModel.preview()), workflow: .constant("workflow"))
    }
}
