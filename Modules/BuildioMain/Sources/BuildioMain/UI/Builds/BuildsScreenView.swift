//
//  BuildsScreenView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 01.10.2021.
//

import SwiftUI
import Models

struct BuildsScreenView: View, PagingView, ScreenBuilder {
    @Environment(\.theme) var theme
    @EnvironmentObject var model: BuildsViewModel
    @EnvironmentObject var navigator: Navigator
    @State private var showNewBuild: Bool = false
    
    func buildItemView(_ item: BuildResponseItemModel) -> some View {
        ListItemWrapper(action: {
            navigator.go(.build(item))
        }, content: {
            BuildRowView(build: item)
        })
    }
    
    @ViewBuilder
    func additionalToolbarItems() -> some View {
        Button {
            navigator.go(.newBuild(nil), theme: theme)
        } label: {
            Image(systemName: "plus")
        }
//        .sheet(isPresented: $showNewBuild) {
//            model.refresh()
//        } content: {
//            newBuildScreen(app: model.app)
//        }
    }
}
