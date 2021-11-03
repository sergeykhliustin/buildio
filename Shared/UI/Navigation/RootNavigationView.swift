//
//  RootNavigationView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 01.10.2021.
//

import SwiftUI

struct RootNavigationView: View {
    var body: some View {
        TabsScreenView()
            .navigationViewStyle(.stack)
    }
}

struct RootNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        RootNavigationView()
    }
}
