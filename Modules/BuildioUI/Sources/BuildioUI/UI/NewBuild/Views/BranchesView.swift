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
import BuildioLogic

struct BranchesView: BaseView {
    @Environment(\.theme) private var theme
    @State var isActiveRoute: Bool = false
    
    @EnvironmentObject var model: BranchesViewModel
    @Binding var branch: String
    private let app: V0AppResponseItemModel
    @State private var focused: Bool = false
    
    init(app: V0AppResponseItemModel, branch: Binding<String>) {
        self.app = app
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
                .modifier(RoundedBorderShadowModifier(focused: focused, horizontalPadding: 8))
                .modifier(RightButtonModifier(icon: .chevron_right, loading: model.value == nil, action: {
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
