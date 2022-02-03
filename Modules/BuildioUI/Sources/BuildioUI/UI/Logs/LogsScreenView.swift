//
//  LogsScreenView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 01.11.2021.
//

import SwiftUI
import Models
import BuildioLogic

struct LogsScreenView: BaseView {
    @EnvironmentObject var model: LogsViewModel
    @Environment(\.fullscreen) private var fullscreen
    private let build: BuildResponseItemModel
    
    init(build: BuildResponseItemModel) {
        self.build = build
    }
    
    var body: some View {
        let fetchRaw: (() -> Void)? = model.canFetchRaw ? { model.fetchRaw() } : nil
        LogsView(logs: model.attributedLogs, fetchRawAction: fetchRaw)
            .toolbar {
                if case .loading = model.state {
                    ProgressView()
                }
            }
    }
}

struct LogsScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LogsScreenView(build: BuildResponseItemModel.preview())
    }
}
