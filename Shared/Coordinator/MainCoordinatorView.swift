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
                .frame(maxWidth: 480)
        } else {
            RootNavigationView()
                .frame(minWidth: 400, idealWidth: 800, minHeight: 600, idealHeight: 800)
                .background(Color.white)
        }
    }
}

struct MainCoordinatorView_Previews: PreviewProvider {
    static var previews: some View {
        MainCoordinatorView()
    }
}
