//
//  BuildScreenView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 24.10.2021.
//

import SwiftUI
import Models
import Combine
import BuildioLogic

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
                    AbortButton {
                        abortConfirmation = true
                    }
                } else {
                    StartBuildButton("Rebuild") {
                        model.rebuild { error in
                            if error == nil {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }
                }
                
                NavigateSettingsItem(title: "Logs", icon: .note_text) {
                    navigator.go(.logs(value), replace: false)
                }
                if value.status != .running {
                    NavigateSettingsItem(title: "Apps & Artifacts", icon: .archivebox) {
                        navigator.go(.artifacts(value), replace: false)
                    }
                }
                
                NavigateSettingsItem(title: "Bitrise.yml", icon: .gearshape_2) {
                    navigator.go(.yml(value), replace: false)
                }
                
                ListItemWrapper {
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
