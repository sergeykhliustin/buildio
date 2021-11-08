//
//  NewBuildScreenView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 01.11.2021.
//

import SwiftUI
import Models

struct NewBuildScreenView: BaseView, OneRouteView {
    @StateObject var model: NewBuildViewModel = NewBuildViewModel()
    
    @State var isActiveRoute: Bool = false
    let router: AppRouter
    
    init(router: AppRouter = AppRouter()) {
        self.router = router
    }
    
    @State private var app: V0AppResponseItemModel?
    @State private var branch: String = ""
    @State private var message: String = ""
    @State private var workflow: String = ""
    
    var body: some View {
        ScrollView {
            NavigationLink("", isActive: $isActiveRoute) {
                AppsScreenView(completion: { app in
                    self.app = app
                    self.isActiveRoute = false
                })
                    .navigationTitle("Select the app")
            }
            .hidden()
            VStack(alignment: .leading) {
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
                if let app = app {
                    Text("Branch:")
                    BranchesView(app: app, branch: $branch)
                    Text("Message:")
                    BTextField("e.g. triggered by Buildio", text: $message)
                    Text("Workflow:")
                    WorkflowsView(app: app, workflow: $workflow)
                }
                
            }
            .padding(.horizontal, 16)
        }
        .font(.footnote)
        .foregroundColor(Color.b_TextBlack)
    }
}

struct NewBuildScreenView_Previews: PreviewProvider {
    static var previews: some View {
        NewBuildScreenView()
    }
}
