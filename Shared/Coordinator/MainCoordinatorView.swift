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
            AuthScreenView(canClose: true)
        } else {
            RootNavigationView()
        }
    }
}

struct MainCoordinatorView_Previews: PreviewProvider {
    static var previews: some View {
        MainCoordinatorView()
    }
}
