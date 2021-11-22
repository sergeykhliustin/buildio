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
    
    init(build: BuildResponseItemModel) {
        self._model = StateObject(wrappedValue: LogsViewModel(build: build))
    }
    
    var body: some View {
        VStack(alignment: .center) {
            if let value = model.attributedLogs {
                LogsTextView(attributed: value)
            } else {
                LogsTextView(attributed: NSAttributedString(string: "Loading logs...", attributes: [.foregroundColor: UIColor.white]))
            }
        }
        .frame(maxHeight: .infinity)
        .navigationTitle("Build #\(String(model.build.buildNumber)) logs")
        .toolbar {
            if case .loading = model.state {
                CustomProgressView()
            }
        }
    }
}

struct LogsScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LogsScreenView(build: BuildResponseItemModel.preview())
    }
}
