//
//  BuildScreenView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 24.10.2021.
//

import SwiftUI
import Models

struct BuildScreenView: BaseView, AppOneRouteView {
    let router: AppRouter
    @State var isActiveRoute: Bool = false
    
    @StateObject var model: BuildViewModel
    @State private var isLogsActive: Bool = false
    
    init(router: AppRouter = AppRouter(), build: BuildResponseItemModel) {
        self.router = router
        self._model = StateObject(wrappedValue: BuildViewModel(build: build))
    }
    
    var body: some View {
        ScrollView {
            if let value = model.value {
                router.navigationLink(route: .logsScreen(value), isActive: $isActiveRoute)

                Button {
                    isActiveRoute.toggle()
                } label: {
                    Group {
                        Image(systemName: "note.text")
                        Text("Logs")
                    }
                    .padding(8)
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
