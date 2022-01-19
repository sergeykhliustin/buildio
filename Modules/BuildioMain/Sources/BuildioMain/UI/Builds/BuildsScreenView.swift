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
            navigator.go(.newBuild(nil))
        } label: {
            Image(systemName: "plus")
        }
    }
}
