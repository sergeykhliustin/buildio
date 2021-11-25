//
//  RootScreenDeprecatedView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 05.11.2021.
//

import SwiftUI

struct RootScreenDeprecatedView: View {
    var body: some View {
        CustomTabView(count: RootScreenConfiguration.screens.count) { index in
            RootScreenConfiguration.screens[index]
        }
    }
}

struct RootScreenDeprecatedView_Previews: PreviewProvider {
    static var previews: some View {
        RootScreenDeprecatedView()
    }
}
