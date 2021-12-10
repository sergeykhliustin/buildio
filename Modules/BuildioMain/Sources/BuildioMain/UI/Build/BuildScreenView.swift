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
    @Environment(\.theme) private var theme
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var model: BuildViewModel
    
    @State var route: Route?
    @State private var abortConfirmation: Bool = false
    @State private var abortReason: String = ""
    
    var body: some View {
        let value = model.value!
        RefreshableScrollView(refreshing: model.isScrollViewRefreshing) {
            navigationLinks(route: $route)
            VStack(spacing: 8) {
                if let error = model.error {
                    Text(error.rawErrorString)
                        .padding(16)
                }
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
        .alert(item: $model.actionError, content: { error in
            Alert(title: Text(error.title), message: Text(error.message))
        })
        .alert(isPresented: $abortConfirmation, AlertConfig.abort({ model.abort(reason: $0) }))
        .toolbar {
            if case .loading = model.state {
                ProgressView()
            }
        }
    }
}

struct BuildScreenView_Previews: PreviewProvider {
    static var previews: some View {
        BuildScreenView()
    }
}
