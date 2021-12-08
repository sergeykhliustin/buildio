//
//  NewBuildScreenView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 01.11.2021.
//

import SwiftUI
import Models
import Combine

struct NewBuildScreenView: View, RoutingView {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var model: NewBuildViewModel = NewBuildViewModel()
    
    @State var isActiveRoute: Bool = false
    
    @State private var app: V0AppResponseItemModel?
    @State private var branch: String = ""
    @State private var message: String = ""
    @State private var workflow: String = ""
    
    init(app: V0AppResponseItemModel? = nil) {
        self._app = State(initialValue: app)
    }
    
    var body: some View {
        ScrollView {
            NavigationLink(isActive: $isActiveRoute) {
                appSelectScreen { app in
                    self.app = app
                    self.isActiveRoute = false
                }
            } label: {
                EmptyView()
            }
            .hidden()

            VStack(alignment: .leading, spacing: 8) {
                Text("App:")
                Button {
                    isActiveRoute.toggle()
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
                    BranchesView(app: app, branch: $branch)
                    Text("Workflow:")
                    WorkflowsView(app: app, workflow: $workflow)
                    Text("Message:")
                    BTextField("e.g. triggered by Buildio", text: $message)
                    
                    HStack(alignment: .center) {
                        Spacer()
                        Button("Start") {
                            model.params = NewBuildViewModelParams(appSlug: app.wrappedValue.slug, branch: branch, workflow: workflow, message: message)
                            model.refresh()
                        }
                        .buttonStyle(SubmitButtonStyle())
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
                    presentationMode.wrappedValue.dismiss()
                }
            })
            .padding(16)
            .disabled(model.state == .loading)
        }
        .font(.footnote)
        .foregroundColor(Color.b_TextBlack)
        .toolbar {
            Button {
                presentationMode.wrappedValue.dismiss()
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
