//
//  LogsScreenView.swift
//  Buildio
//
//  Created by severehed on 01.11.2021.
//

import SwiftUI
import Models

struct LogsScreenView: BaseView {
    @StateObject var model: LogsViewModel
    
    init(build: V0BuildResponseItemModel) {
        self._model = StateObject(wrappedValue: LogsViewModel(build: build))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if case .loading = model.state {
                ProgressView().padding(16)
            }
            if let value = model.value {
                ScrollView {
                    ScrollViewReader { reader in
                        ForEach(value.logChunks, id: \.chunk) { item in
                            Text(item.chunk)
                                .border(Color.b_BorderLight, width: 1)
                                .cornerRadius(4)
                                .padding(16)
                        }
                        .onAppear {
                            reader.scrollTo(value.logChunks.last?.chunk, anchor: .center)
                        }
                    }
                    
                }
            }
        }
        .navigationTitle("Build #\(String(model.build.buildNumber)) logs")
    }
}

struct LogsScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LogsScreenView(build: V0BuildResponseItemModel.preview())
    }
}
