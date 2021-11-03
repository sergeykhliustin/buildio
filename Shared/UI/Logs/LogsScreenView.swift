//
//  LogsScreenView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 01.11.2021.
//

import SwiftUI
import Models
import Rainbow

struct LogsScreenView: BaseView {
    @StateObject var model: LogsViewModel
    @Namespace var bottomID
    
    init(build: V0BuildResponseItemModel) {
        self._model = StateObject(wrappedValue: LogsViewModel(build: build))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if let value = model.attributedLogs {
                LogsTextView(attributed: value)
                    .padding(.horizontal, 8)
            } else {
                if case .loading = model.state {
                    ProgressView().padding(16)
                }
            }
        }
        .navigationTitle("Build #\(String(model.build.buildNumber)) logs")
        .toolbar {
            if case .loading = model.state {
                ProgressView().padding(16)
            }
        }
    }
}

struct LogsScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LogsScreenView(build: V0BuildResponseItemModel.preview())
    }
}
