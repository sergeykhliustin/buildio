//
//  BuildScreenView.swift
//  Buildio
//
//  Created by severehed on 24.10.2021.
//

import SwiftUI
import Models

struct BuildScreenView: View {
    
    @State var model: V0BuildListAllResponseItemModel
    var body: some View {
        BuildRowView(expanded: true, model: model)
            .navigationTitle(model.slug)
    }
}

struct BuildScreenView_Previews: PreviewProvider {
    static var previews: some View {
        BuildScreenView(model: V0BuildListAllResponseItemModel.preview())
    }
}
