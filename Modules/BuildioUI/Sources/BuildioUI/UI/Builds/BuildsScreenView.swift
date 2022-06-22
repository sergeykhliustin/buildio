//
//  BuildsScreenView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 01.10.2021.
//

import SwiftUI
import Models
import BuildioLogic

struct BuildsScreenView: View, PagingView {
    @Environment(\.theme) var theme
    @EnvironmentObject var model: BuildsViewModel
    @EnvironmentObject private var navigator: Navigator
    @EnvironmentObject private var screenFactory: ScreenFactory
    
    func buildItemView(_ item: BuildResponseItemModel) -> some View {
        ListItemWrapper(action: {
            navigator.go(.build(item), replace: model.app == nil)
        }, content: {
            screenFactory.buildRowView(build: item)
        })
    }
    
    @ViewBuilder
    func additionalToolbarItems() -> some View {
        HStack {
            if model.app == nil {
                Button {
                    navigator.go(.activities, replace: true)
                } label: {
                    Image(.bell)
                }
            }
            
            Button {
                navigator.go(.newBuild(nil))
            } label: {
                Image(.plus)
            }
        }
    }
}
