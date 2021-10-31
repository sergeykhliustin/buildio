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
    var body: some View {
        BuildRowView(model: model)
            .navigationTitle("Build #\(model.buildNumber)")
    }
}

struct BuildScreenView_Previews: PreviewProvider {
    static var previews: some View {
        BuildScreenView(model: V0BuildResponseItemModel.preview())
    }
}
