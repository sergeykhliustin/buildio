//
//  BuildScreenView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 24.10.2021.
//

import SwiftUI
import Models
import Combine

struct ActionItem: View {
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
    
    @StateObject var model: BuildViewModel = BuildViewModel()
    @State private var selection: String?
    @State private var isActiveLogs: Bool = false
    @State private var error: ErrorResponse?
    let build: BuildResponseItemModel
    @State private var isActiveArtifacts: Bool = false
    
    var body: some View {
        let value = model.value ?? self.build
        ScrollView {
            VStack(spacing: 8) {
                navigationBuildLogs(build: value, isActive: $isActiveLogs)
                navigationBuildArtifacts(build: value, isActive: $isActiveArtifacts)
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
                ActionItem(title: "Logs", icon: "note.text") {
                    selection = value.slug
                    isActiveLogs = true
                }
                if value.status != .running {
                    ActionItem(title: "Apps & Artifacts", icon: "archivebox") {
                        isActiveArtifacts = true
                    }
                }
                
                ListItemWrapper {
                    
                } content: {
                    BuildView(model: .constant(value))
                }
            }
        }
        .navigationTitle("Build #\(String(value.buildNumber))")
        .toolbar {
            if case .loading = model.state {
                ProgressView()
            }
        }
        .onAppear {
            model.update(build)
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
