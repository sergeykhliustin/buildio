//
//  BuildScreenView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 24.10.2021.
//

import SwiftUI
import Models

struct BuildScreenView: BaseView {
    @StateObject var model: BuildViewModel
    @State private var isLogsActive: Bool = false
    
    init(build: V0BuildResponseItemModel) {
        self._model = StateObject(wrappedValue: BuildViewModel(build: build))
    }
    
    var body: some View {
        ScrollView {
            NavigationLink(isActive: $isLogsActive) {
                if let value = model.value {
                    LogsScreenView(build: value)
                }
            } label: {
                Group {
                    Image(systemName: "note.text")
                    Text("Logs")
                }
                .padding(8)
            }
            if let value = Binding($model.value) {
                BuildRowView(model: value)
            }
            
//            if let value = model.value {
//                BuildRowView(model: value)
//            }
        }
        .navigationTitle("Build #\(model.value!.buildNumber)")
        .toolbar {
            if case .loading = model.state {
                ProgressView()
            }
        }
    }
}

struct BuildScreenView_Previews: PreviewProvider {
    static var previews: some View {
        BuildScreenView(build: V0BuildResponseItemModel.preview())
    }
}
