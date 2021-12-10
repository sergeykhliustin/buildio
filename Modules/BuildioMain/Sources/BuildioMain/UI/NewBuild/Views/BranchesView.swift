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
    
    override class var shouldRefreshOnInit: Bool {
        return true
    }
    
    init(app: Binding<V0AppResponseItemModel>) {
        self._app = app
    }
    
    override func fetch() -> AnyPublisher<[String], ErrorResponse> {
        ApplicationAPI()
            .branchList(appSlug: app.slug)
            .map({ $0.data ?? [] })
            .eraseToAnyPublisher()
    }
}

struct BranchesView: BaseView {
    @Environment(\.theme) private var theme
    @State var isActiveRoute: Bool = false
    
    @StateObject var model: BranchesViewModel
    @Binding var branch: String
    @Binding var app: V0AppResponseItemModel
    @State private var focused: Bool = false
    
    init(app: Binding<V0AppResponseItemModel>, branch: Binding<String>) {
        self._app = app
        _model = StateObject(wrappedValue: BranchesViewModel(app: app))
        _branch = branch
    }
    
    var body: some View {
        ZStack {
            NavigationLink(isActive: $isActiveRoute) {
                SelectStringScreenView(model.value ?? []) { branch in
                    self.branch = branch
                }
                .navigationTitle("Select branch:")
            } label: {
                EmptyView()
            }
            .hidden()
            
            TextField("Select branch",
                      text: $branch,
                      onEditingChanged: { self.focused = $0 })
                .frame(height: 44)
                .modifier(RoundedBorderShadowModifier(borderColor: focused ? theme.accentColor : theme.borderColor, horizontalPadding: 8))
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
        }
    }
}

struct BranchesView_Previews: PreviewProvider {
    static var previews: some View {
        BranchesView(app: .constant(V0AppResponseItemModel.preview()), branch: .constant("branch"))
    }
}
