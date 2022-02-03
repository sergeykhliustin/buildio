//
//  NewBuildScreenView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 01.11.2021.
//

import SwiftUI
import Models
import Combine
import BuildioLogic

struct NewBuildScreenView: View {
    @EnvironmentObject private var navigator: Navigator
    @EnvironmentObject private var screenFactory: ScreenFactory
    @Environment(\.theme) var theme
    @EnvironmentObject var model: NewBuildViewModel
    
    @State private var app: V0AppResponseItemModel?
    @State private var branch: String = ""
    @State private var message: String = ""
    @State private var workflow: String = ""
    @State private var focusedMessage: Bool = false
    
    init(app: V0AppResponseItemModel? = nil) {
        self._app = State(initialValue: app)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                Text("App:")
                Button {
                    navigator.go(.appSelect({ app in
                        self.app = app
                        navigator.popToRoot()
                    }))
                } label: {
                    HStack {
                        Text(app?.title ?? "Select the app")
                            .contentShape(Rectangle())
                            .cornerRadius(4)
                            .frame(height: 44)
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .modifier(RoundedBorderShadowModifier())
                }
                .buttonStyle(.plain)
                if let app = Binding($app) {
                    Text("Branch:")
                    screenFactory
                        .branchesView(app: app.wrappedValue, branch: $branch)
                    Text("Workflow:")
                    screenFactory
                        .workflowsView(app: app.wrappedValue, workflow: $workflow)
                    Text("Message:")
                    TextField("e.g. triggered by Buildio",
                              text: $message,
                              onEditingChanged: { self.focusedMessage = $0 })
                        .frame(height: 44)
                        .modifier(RoundedBorderShadowModifier(focused: focusedMessage, horizontalPadding: 8))
                    
                    HStack(alignment: .center) {
                        Spacer()
                        StartBuildButton("Start") {
                            model.params = NewBuildViewModelParams(appSlug: app.wrappedValue.slug, branch: branch, workflow: workflow, message: message)
                            model.refresh()
                        }
                        .disabled(!validator)
                        .frame(alignment: .center)
                        Spacer()
                    }
                }
                if model.state == .loading {
                    HStack {
                        Spacer()
                        ProgressView().padding(8)
                        Spacer()
                    }
                }
                if let error = model.errorString {
                    Text(error).padding()
                }
                
            }
            .onReceive(model.$state, perform: { state in
                if state == .value {
                    navigator.dismiss()
                }
            })
            .padding(16)
            .disabled(model.state == .loading)
        }
        .font(.footnote)
        .toolbar {
            Button {
                navigator.dismiss()
            } label: {
                Image(systemName: "xmark")
            }

        }
    }
    
    private var validator: Bool {
        return app != nil && !branch.isEmpty && !workflow.isEmpty && model.state != .loading
    }
}

struct NewBuildScreenView_Previews: PreviewProvider {
    static var previews: some View {
        NewBuildScreenView()
    }
}
