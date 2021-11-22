//
//  BuildScreenView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 24.10.2021.
//

import SwiftUI
import Models

struct BuildScreenView: BaseView, RoutingView {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var model: BuildViewModel
    @State private var selection: String?
    @State private var isActiveLogs = false
    
    init(build: BuildResponseItemModel) {
        self._model = StateObject(wrappedValue: BuildViewModel(build: build))
    }
    
    var body: some View {
        ScrollView {
            if let value = model.value {
                HStack {
                    navigationBuildLogs(build: value, isActive: $isActiveLogs)
//                    navigationBuildLogs(build: value, selection: $selection)
                    Button {
//                        selection = value.slug
                        isActiveLogs.toggle()
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
                .navigationTitle("Build #\(String(value.buildNumber))")
            }
            if let value = Binding($model.value) {
                BuildView(model: value)
            }
        }
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
