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
    @StateObject var model: LogsViewModel = LogsViewModel()
    @State var build: BuildResponseItemModel
    
    var body: some View {
        LogsView(logs: $model.attributedLogs)
            .navigationTitle("Build #\(String(build.buildNumber)) logs")
            .toolbar {
                if case .loading = model.state {
                    ProgressView()
                }
            }
            .onAppear {
                model.update(self.build)
            }
    }
}

struct LogsScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LogsScreenView(build: BuildResponseItemModel.preview())
    }
}
