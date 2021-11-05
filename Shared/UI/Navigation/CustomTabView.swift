//
//  CustomTabView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 05.11.2021.
//

import SwiftUI

private class CustomTabViewModel {
    var cachedViews: [Int: AnyView] = [:]
}

struct CustomTabView: View {
    private let model = CustomTabViewModel()
    let count: Int
    var content: (Int) -> RootScreen
    @State private var selected: Int = 0
    
    #if os(iOS)
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $selected) {
                ForEach(0..<count) { index in
                    NavigationView {
                        content(index).screen()
                            .navigationTitle(content(index).name)
                    }
                }
            }
            
            CustomTabBar(count: count, selected: $selected, content: { index in
                Image(systemName: content(index).iconName)
                Text(content(index).name)
                    .font(.footnote)
            })
            
        }
    }
    #elseif os(macOS)
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                TabView(selection: $selected) {
                    ForEach(0..<count) { index in
                        content(index).screen()
                            .navigationTitle(content(index).name)
                    }
                }
                CustomTabBar(count: count, selected: $selected, content: { index in
                    Image(systemName: content(index).iconName)
                    Text(content(index).name)
                        .font(.footnote)
                })
            }
            .background(Color.white)
        }
    }
    #endif
}
