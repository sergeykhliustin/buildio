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
    
    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            buildIphone()
        } else {
            buildIpad()
        }
    }
    
    @ViewBuilder
    private func buildIphone() -> some View {
        VStack(spacing: 0) {
            TabView(selection: $selected) {
                ForEach(0..<count) { index in
                    NavigationView {
                        content(index).screen()
                            .navigationTitle(content(index).name)
                    }
                    .accentColor(.b_TextBlack)
                }
            }
            
            CustomTabBar(count: count, selected: $selected, content: { index in
                Image(systemName: content(index).iconName)
                Text(content(index).name)
                    .font(.footnote)
            })
            
        }
    }
    
    @ViewBuilder
    private func buildIpad() -> some View {
        NavigationView {
            VStack(spacing: 0) {
                TabView(selection: $selected) {
                    ForEach(0..<count) { index in
                        content(index).screen()
                    }
                }
                CustomTabBar(count: count, selected: $selected, content: { index in
                    Image(systemName: content(index).iconName)
                    Text(content(index).name)
                        .font(.footnote)
                })
            }
            .navigationTitle(content(selected).name)
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.white)
        }
    }
}
