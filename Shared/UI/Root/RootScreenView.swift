//
//  RootScreenView.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 25.11.2021.
//

import SwiftUI

struct RootScreenView: View {
    @State private var selection: Int = 0
    
    var body: some View {
        RootTabBarWrapper(selection: $selection) {
            RootTabView(selection: $selection)
        }
    }
}

struct RootScreenView_Previews: PreviewProvider {
    static var previews: some View {
        RootScreenView()
    }
}
