//
//  BuildsScreenView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 01.10.2021.
//

import SwiftUI
import Models

struct BuildsScreenView: View, PagingView, RoutingView {
    @EnvironmentObject var model: BuildsViewModel
//    @StateObject var model: BuildsViewModel
    @State private var showNewBuild: Bool = false
    @State private var route: Route?
    
    func buildItemView(_ item: BuildResponseItemModel) -> some View {
        ListItemWrapper(action: {
            route = .build(item)
        }, content: {
            BuildRowView(build: item, route: $route)
        })
    }
    
    @ViewBuilder
    func navigationLinks() -> some View {
        navigationLinks(route: $route)
    }
    
    @ViewBuilder
    func additionalToolbarItems() -> some View {
        Button {
            showNewBuild.toggle()
        } label: {
            Image(systemName: "plus")
        }
        .sheet(isPresented: $showNewBuild) {
            model.refresh()
        } content: {
            NavigationView {
                NewBuildScreenView(app: model.app)
                    .navigationTitle("Start a build")
            }
        }
    }
}
