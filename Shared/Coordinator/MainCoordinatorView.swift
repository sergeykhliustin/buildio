//
//  MainCoordinatorView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 01.10.2021.
//

import SwiftUI

struct MainCoordinatorView: View {
    @StateObject var tokenManager = TokenManager.shared
    
    var body: some View {
        if tokenManager.token == nil {
            TokenFigmaScreenView()
                .animation(.easeIn(duration: 0.5))
                .transition(.move(edge: .bottom))
        } else {
            RootNavigationView()
                .background(Color.white)
        }
    }
}

struct MainCoordinatorView_Previews: PreviewProvider {
    static var previews: some View {
        MainCoordinatorView()
    }
}
