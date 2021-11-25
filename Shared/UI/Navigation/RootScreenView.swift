//
//  RootScreenView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 05.11.2021.
//

import SwiftUI

struct RootScreenView: View {
    private let configuration = RootScreenConfiguration()
    
    var body: some View {
        CustomTabView(count: configuration.screens.count) { index in
            configuration.screens[index]
        }
    }
}

struct CustomTabsScreenView_Previews: PreviewProvider {
    static var previews: some View {
        RootScreenView()
    }
}
