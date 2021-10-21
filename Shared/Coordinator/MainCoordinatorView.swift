//
//  MainCoordinatorView.swift
//  Buildio
//
//  Created by severehed on 01.10.2021.
//

import SwiftUI

struct MainCoordinatorView: View {
    @ObservedObject var coordinator = MainCoordinator()
    
    var body: some View {
        if coordinator.token == nil {
            TokenFigmaScreenView(token: $coordinator.token)
        } else if let me = coordinator.user {
            RootNavigationView()
        } else {
            FullscreenLoadingView()
        }
    }
}

struct MainCoordinatorView_Previews: PreviewProvider {
    static var previews: some View {
        MainCoordinatorView()
    }
}
