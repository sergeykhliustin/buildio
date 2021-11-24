//
//  BuildScreenView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 24.10.2021.
//

import SwiftUI
import Models

private struct Item: View {
    let title: String
    let icon: String
    let action: () -> Void
    var body: some View {
        ListItemWrapper(action: action) {
            HStack {
                Image(systemName: icon)
                Text(title)
                Spacer()
                Image(systemName: "chevron.right")
            }
            .frame(height: 44)
            .padding(.horizontal, 16)
        }
    }
}

struct BuildScreenView: BaseView, RoutingView {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var model: BuildViewModel
    
    @SceneStorage("isActiveLogs")
    private var isActiveLogs = false
    
    @State private var error: ErrorResponse?
    
    init(build: BuildResponseItemModel) {
        self._model = StateObject(wrappedValue: BuildViewModel(build: build))
    }
    
    var body: some View {
        let value = model.value!
        ScrollView {
            navigationBuildLogs(build: value, isActive: $isActiveLogs).hidden()
            if value.status != .running {
                Button {
                    model.rebuild { error in
                        if error == nil {
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            self.error = error
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "tortoise")
                        Text("Rebuild")
                    }
                }
                .buttonStyle(SubmitButtonStyle(edgeInsets: EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)))
                .cornerRadius(20)
                .alert(item: $error, content: { error in
                    Alert(title: Text("Failed to start the Build"), message: Text(error.rawErrorString), dismissButton: nil)
                })
            }
            Item(title: "Logs", icon: "note.text") {
                isActiveLogs.toggle()
            }
            if value.status != .running {
                Item(title: "Apps & Artifacts", icon: "archivebox") {
                    
                }
            }
            
            ListItemWrapper {
                
            } content: {
                BuildView(model: .constant(value))
            }
        }
        .navigationTitle("Build #\(String(value.buildNumber))")
        .toolbar {
            if case .loading = model.state {
                ProgressView()
            }
        }
    }
    
    func isError() -> Binding<Bool> {
        return Binding(get: { error != nil }, set: { newValue in if !newValue { error = nil } })
    }
}

struct BuildScreenView_Previews: PreviewProvider {
    static var previews: some View {
        BuildScreenView(build: BuildResponseItemModel.preview())
    }
}
