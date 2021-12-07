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
    @EnvironmentObject var model: BuildViewModel
    
    @State private var rebuildError: ErrorResponse?
    @State private var abortError: ErrorResponse?
    @State var route: Route?
    @State private var abortConfirmation: Bool = false
    @State private var abortReason: String = ""
    
    var body: some View {
        let value = model.value!
        RefreshableScrollView(refreshing: model.isScrollViewRefreshing) {
            navigationLinks(route: $route)
            VStack(spacing: 8) {
                if value.status == .running {
                    Button {
                        abortConfirmation = true
                    } label: {
                        HStack {
                            Image(systemName: "nosign")
                            Text("Abort")
                        }
                    }
                    .buttonStyle(AbortButtonStyle())
                } else {
                    Button {
                        model.rebuild { error in
                            if error == nil {
                                presentationMode.wrappedValue.dismiss()
                            } else {
                                self.rebuildError = error
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: "hammer")
                            Text("Rebuild")
                        }
                    }
                    .buttonStyle(SubmitButtonStyle(edgeInsets: EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)))
                    .cornerRadius(20)
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
                    BuildView(model: value, progress: model.progress)
                }
            }
            .padding(.vertical, 8)
        }
        .alert(item: $rebuildError, content: { error in
            Alert(title: Text("Failed to start the Build"), message: Text(error.rawErrorString), dismissButton: nil)
        })
        .alert(item: $abortError, content: { error in
            Alert(title: Text("Failed to abort the Build"), message: Text(error.rawErrorString), dismissButton: nil)
        })
        .alert(isPresented: $abortConfirmation,
               AlertConfig(title: "Are you sure you want to abort the current Build?",
                           message: "You can specify a reason below for aborting this build. Your text will be included in the build email sent to team members. Leave blank if you are okay with the default message.",
                           placeholder: "Abort reason (optional)",
                           accept: "Abort",
                           cancel: "Cancel",
                           action: { text in
            model.abort(reason: text) { error in
                self.abortError = error
            }
        }))
        .toolbar {
            if case .loading = model.state {
                ProgressView()
            }
        }
    }
    
    func isError() -> Binding<Bool> {
        return Binding(get: { rebuildError != nil }, set: { newValue in if !newValue { rebuildError = nil } })
    }
}

struct BuildScreenView_Previews: PreviewProvider {
    static var previews: some View {
        BuildScreenView()
    }
}
