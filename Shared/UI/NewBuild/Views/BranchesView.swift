//
//  BranchesView.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 08.11.2021.
//

import SwiftUI
import Models
import Combine
import BitriseAPIs

final class BranchesViewModel: BaseViewModel<[String]> {
    @Binding var app: V0AppResponseItemModel
    
    init(app: Binding<V0AppResponseItemModel>) {
        self._app = app
    }
    
    override func fetch(params: Any?) -> AnyPublisher<[String], ErrorResponse> {
        ApplicationAPI()
            .branchList(appSlug: app.slug)
            .map({ $0.data ?? [] })
            .eraseToAnyPublisher()
    }
}

struct BranchesView: BaseView {
    @State var isActiveRoute: Bool = false
    
    @StateObject var model: BranchesViewModel
    @Binding var branch: String
    @Binding var app: V0AppResponseItemModel
    
    init(app: Binding<V0AppResponseItemModel>, branch: Binding<String>) {
        self._app = app
        _model = StateObject(wrappedValue: BranchesViewModel(app: app))
        _branch = branch
    }
    
    var body: some View {
        BTextField("Select branch", text: $branch)
            .modifier(RightButtonModifier(icon: "chevron.right", loading: model.value == nil, action: {
                isActiveRoute.toggle()
            }))
            .onReceive(model.$value) { branches in
                if branch.isEmpty {
                    branch = branches?.first ?? ""
                }
            }
            .onChange(of: app) { newValue in
                branch = ""
                model.refresh()
            }
        
        NavigationLink(isActive: $isActiveRoute) {
            SelectStringScreenView(model.value ?? []) { branch in
                self.branch = branch
            }
            .navigationTitle("Select branch:")
        } label: {
            EmptyView()
        }
        .hidden()
    }
}

struct BranchesView_Previews: PreviewProvider {
    static var previews: some View {
        BranchesView(app: .constant(V0AppResponseItemModel.preview()), branch: .constant("branch"))
    }
}
