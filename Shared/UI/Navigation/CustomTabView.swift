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

private struct FullscreenEnvironmentKey: EnvironmentKey {
    static var defaultValue: Binding<Bool> = .constant(false)
}

extension EnvironmentValues {
    var fullscreen: Binding<Bool> {
        get {
            self[FullscreenEnvironmentKey.self]
        }
        set {
            self[FullscreenEnvironmentKey.self] = newValue
        }
    }
}

struct CustomTabView: View {
    private let model = CustomTabViewModel()
    let count: Int
    var content: (Int) -> RootScreen
    @State private var selected: Int = 0
    @State private var fullscreen: Bool = false
    @StateObject private var keyboard: KeyboardObserver = KeyboardObserver()
    
    init(count: Int, content: @escaping (Int) -> RootScreen) {
        self.count = count
        self.content = content
    }
    
    var body: some View {
        buildBody()
            .accentColor(.b_TextBlack)
            .progressViewStyle(CustomProgressViewStyle())
    }
    
    @ViewBuilder
    private func buildBody() -> some View {
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
                    if content(index).requiresNavigation {
                        NavigationView {
                            content(index).screen()
                                .navigationTitle(content(index).name)
                        }
                        .navigationViewStyle(.stack)
                    } else {
                        content(index).screen()
                    }
                }
            }
            
            if !fullscreen && !keyboard.isVisible {
                CustomTabBar(count: count, selected: $selected, content: { index in
                    Image(systemName: content(index).iconName + (selected == index ? ".fill" : ""))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                    Text(content(index).name)
                        .font(.footnote)
                })
                    .edgesIgnoringSafeArea(.horizontal)
            }
        }
        .environment(\.fullscreen, $fullscreen)
    }
    
    @ViewBuilder
    private func buildIpad() -> some View {
        HStack(spacing: 0) {
            CustomTabBar(style: .vertical, count: count, selected: $selected, content: { index in
                Image(systemName: content(index).iconName + (selected == index ? ".fill" : ""))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                Text(content(index).name)
                    .font(.footnote)
            })
                .zIndex(1)
            
            TabView(selection: $selected) {
                ForEach(0..<count) { index in
                    if content(index).requiresNavigation {
                        NavigationView {
                            content(index).screen()
                                .background(Color.white)
                                .navigationTitle(content(index).name)
                        }
                    } else {
                        content(index).screen()
                    }
                }
            }
        }
        .environment(\.fullscreen, $fullscreen)
    }
}
