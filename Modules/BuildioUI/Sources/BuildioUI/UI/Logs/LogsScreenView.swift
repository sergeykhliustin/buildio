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
    @EnvironmentObject var model: LogsViewModel
    
    var body: some View {
        LogsView(logs: $model.attributedLogs)
            .toolbar {
                if case .loading = model.state {
                    ProgressView()
                }
            }
    }
}

struct LogsScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LogsScreenView()
            .environmentObject(LogsViewModel(build: BuildResponseItemModel.preview()))
    }
}
