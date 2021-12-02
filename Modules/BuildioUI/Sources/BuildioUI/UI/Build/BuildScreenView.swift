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
    @State private var error: ErrorResponse?
    @Binding var build: BuildResponseItemModel
    
    @State var route: Route?
    
    var body: some View {
        let value = model.value ?? self.build
        ScrollView {
            navigationLinks(route: $route)
            VStack(spacing: 8) {
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
                    self.route = .logs(value)
                }
                if value.status != .running {
                    ActionItem(title: "Apps & Artifacts", icon: "archivebox") {
                        self.route = .artifacts(value)
                    }
                }
                
                ListItemWrapper {
                    
                } content: {
                    BuildView(model: .constant(value))
                }
            }
        }
        .toolbar {
            if case .loading = model.state {
                ProgressView()
            }
        }
        .onChange(of: build, perform: { newValue in
            model.update(build)
        })
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
        BuildScreenView(build: .constant(BuildResponseItemModel.preview()))
    }
}
