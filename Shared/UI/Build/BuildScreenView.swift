//
//  BuildScreenView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 24.10.2021.
//

import SwiftUI
import Models

struct BuildScreenView: BaseView, AppOneRouteView {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let router: AppRouter
    @State var isActiveRoute: Bool = false
    
    @StateObject var model: BuildViewModel
    @State private var isLogsActive: Bool = false
    
    init(router: AppRouter = AppRouter(), build: BuildResponseItemModel) {
        self.router = router
        self._model = StateObject(wrappedValue: BuildViewModel(build: build))
    }
    
    var body: some View {
        router.navigationLink(route: .logsScreen, isActive: $isActiveRoute, params: model.value).hidden()
        ScrollView {
            if let value = model.value {
                HStack {
                    Button {
                        isActiveRoute = true
                    } label: {
                        Image(systemName: "note.text")
                        Text("Logs")
                    }
                    .padding(16)
                    if value.status != .running {
                        Button {
                            model.rebuild { error in
                                if error == nil {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                        } label: {
                            Text("Rebuild")
                        }
                        .buttonStyle(SubmitButtonStyle())
                    }
                }
            }
            if let value = Binding($model.value) {
                BuildView(model: value)
            }
        }
        .navigationTitle("Build #\(String(model.value!.buildNumber))")
        .toolbar {
            if case .loading = model.state {
                ProgressView()
            }
        }
    }
}

struct BuildScreenView_Previews: PreviewProvider {
    static var previews: some View {
        BuildScreenView(build: BuildResponseItemModel.preview())
    }
}
