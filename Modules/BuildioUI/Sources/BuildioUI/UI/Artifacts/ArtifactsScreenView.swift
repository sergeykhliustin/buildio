//
//  ArtifactsScreenView.swift
//  
//
//  Created by Sergey Khliustin on 30.11.2021.
//

import SwiftUI
import Models

struct ArtifactsScreenView: PagingView {
    @StateObject var model: ArtifactsViewModel
    
    init(build: BuildResponseItemModel) {
        self._model = StateObject(wrappedValue: ArtifactsViewModel(build: build))
    }
    
    func buildItemView(_ item: V0ArtifactListElementResponseModel) -> some View {
        ListItemWrapper(action: {}, content: {
            Text(string(item: item))
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
        })
            .navigationTitle("Artifacts")
    }
    
    private func string(item: V0ArtifactListElementResponseModel) -> String {
        return Mirror(reflecting: item).children.map({ ($0.label ?? "null") + ": " + String(describing: $0.value) }).joined(separator: "\n")
    }
}
