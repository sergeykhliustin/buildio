//
//  BuildScreenView.swift
//  Buildio
//
//  Created by severehed on 24.10.2021.
//

import SwiftUI
import Models

struct BuildScreenView: View {
    @State var model: V0BuildResponseItemModel
    @State private var isLogsActive: Bool = false
    
    var body: some View {
        ScrollView {
            NavigationLink(isActive: $isLogsActive) {
                LogsScreenView(build: model)
            } label: {
                Group {
                    Image(systemName: "note.text")
                    Text("Logs")
                }
                .padding(8)
            }
            BuildRowView(model: model)
        }
        .navigationTitle("Build #\(model.buildNumber)")
    }
}

struct BuildScreenView_Previews: PreviewProvider {
    static var previews: some View {
        BuildScreenView(model: V0BuildResponseItemModel.preview())
    }
}
