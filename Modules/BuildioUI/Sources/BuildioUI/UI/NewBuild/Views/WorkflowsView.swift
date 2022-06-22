//
//  BranchesView.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 08.11.2021.
//

import SwiftUI
import Models
import Combine
import BuildioLogic

struct WorkflowsView: BaseView {
    @Environment(\.theme) private var theme
    @State var isActiveRoute: Bool = false
    
    @EnvironmentObject var model: WorkflowsViewModel
    @Binding var workflow: String
    private let app: V0AppResponseItemModel
    @State private var focused: Bool = false
    
    init(app: V0AppResponseItemModel, workflow: Binding<String>) {
        self.app = app
        _workflow = workflow
    }
    
    var body: some View {
        ZStack {
            NavigationLink(isActive: $isActiveRoute) {
                SelectStringScreenView(model.value ?? []) { workflow in
                    self.workflow = workflow
                }
                .navigationTitle("Select workflow:")
            } label: {
                EmptyView()
            }
            .hidden()
            
            TextField("Select workflow",
                      text: $workflow,
                      onEditingChanged: { self.focused = $0 })
                .frame(height: 44)
                .modifier(RoundedBorderShadowModifier(focused: focused, horizontalPadding: 8))
                .modifier(RightButtonModifier(icon: .chevron_right, loading: model.value == nil, action: {
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
        }
    }
}
