//
//  BuildScreenView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 24.10.2021.
//

import SwiftUI
import Models
import Combine

struct BuildScreenView: BaseView {
    @EnvironmentObject var navigator: Navigator
    @Environment(\.theme) var theme
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var model: BuildViewModel
    
    @State private var abortConfirmation: Bool = false
    @State private var abortReason: String = ""
    
    var body: some View {
        let value = model.value!
        RefreshableScrollView(refreshing: model.isScrollViewRefreshing) {
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
                
                IconActionItem(title: "Logs", icon: "note.text") {
                    navigator.go(.logs(value))
                }
                if value.status != .running {
                    IconActionItem(title: "Apps & Artifacts", icon: "archivebox") {
                        navigator.go(.artifacts(value))
                    }
                }
                
                ListItemWrapper {
                    
                } content: {
                    BuildView(model: value, progress: model.progress)
                }
            }
//            .padding(.vertical, 8)
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
