//
//  MainCoordinatorView.swift
//  Buildio
//
//  Created by severehed on 01.10.2021.
//

import SwiftUI

struct MainCoordinatorView: View {
    @ObservedObject var tokenManager = TokenManager.shared
    
    var body: some View {
        if tokenManager.currentToken == nil {
            TokenFigmaScreenView()
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
