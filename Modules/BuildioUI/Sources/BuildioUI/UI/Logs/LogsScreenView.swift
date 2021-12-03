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
    let build: BuildResponseItemModel
    
    var body: some View {
        LogsView(logs: $model.attributedLogs)
            .toolbar {
                if case .loading = model.state {
                    ProgressView()
                }
            }
            .onChange(of: build, perform: { newValue in
                model.update(newValue)
            })
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
