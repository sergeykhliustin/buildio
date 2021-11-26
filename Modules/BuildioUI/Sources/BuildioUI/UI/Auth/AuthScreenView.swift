//
//  AuthScreenView.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 24.11.2021.
//

import SwiftUI

struct AuthScreenView: View {
    private let canClose: Bool
    private let onCompletion: (() -> Void)?
    
    init(canClose: Bool = false, onCompletion: (() -> Void)? = nil) {
        self.canClose = canClose
        self.onCompletion = onCompletion
    }
    
    var body: some View {
        NavigationView {
            TokenFigmaView(canClose: canClose, onCompletion: onCompletion)
        }
        .navigationViewStyle(.stack)
    }
}

struct AuthScreenView_Previews: PreviewProvider {
    static var previews: some View {
        AuthScreenView()
    }
}
