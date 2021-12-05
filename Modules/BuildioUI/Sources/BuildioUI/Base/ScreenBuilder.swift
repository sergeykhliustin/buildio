//
//  ScreenBuilder.swift
//  
//
//  Created by Sergey Khliustin on 04.12.2021.
//

import Models
import SwiftUI

protocol ScreenBuilder: View {
    
}

extension ScreenBuilder {
    @ViewBuilder
    func buildsScreen(app: V0AppResponseItemModel? = nil) -> some View {
        BuildsScreenView()
            .environmentObject(BuildsViewModel(app: app))
            .navigationTitle(app?.title ?? "Builds")
    }
    
    @ViewBuilder
    func appsScreen() -> some View {
        AppsScreenView()
            .environmentObject(ViewModelResolver.resolve(AppsViewModel.self))
            .navigationTitle("Apps")
    }
    
    @ViewBuilder
    func appSelectScreen(completion: @escaping ((V0AppResponseItemModel) -> Void)) -> some View {
        AppsScreenView(completion: completion)
            .environmentObject(ViewModelResolver.resolve(AppsViewModel.self))
            .navigationTitle("Select the app")
    }
}
