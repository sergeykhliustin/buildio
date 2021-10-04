//
//  BuildsScreenView.swift
//  Buildio
//
//  Created by severehed on 01.10.2021.
//

import SwiftUI
import Models

struct BuildsScreenView: View, RefreshableView {
    typealias VALUE = [V0BuildListAllResponseItemModel]
    @ObservedObject var model: BaseViewModel<[V0BuildListAllResponseItemModel]> = BuildsViewModel()
    
    func buildValueView(_ value: [V0BuildListAllResponseItemModel]) -> some View {
        VStack {
            HStack {
                Spacer()
                Button("Refresh", action: model.refresh)
            }
            List(value) { item in
                let mirror = Mirror(reflecting: item)
                let string = mirror.children.map({ "\($0.label ?? ""): \($0.value)" }).joined(separator: "\n")
                Text(string)
            }
        }
    }
}

struct BuildsView_Previews: PreviewProvider {
    static var previews: some View {
        BuildsScreenView()
    }
}
