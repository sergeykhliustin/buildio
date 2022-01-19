//
//  ThemeConfiguratorScreenView.swift
//  
//
//  Created by Sergey Khliustin on 19.01.2022.
//

import Foundation
import SwiftUI

struct ThemeConfiguratorScreenView: View {
    @Environment(\.lightTheme) var lightTheme
    @State private var selectedKey: String?
    @State private var selectedColor: CGColor = Color.clear.cgColor!
    
    var body: some View {
        let dict = lightTheme.wrappedValue.dictionary as? [String: String] ?? [:]
        
        ScrollView {
            VStack(spacing: 8) {
                if let selectedKey = selectedKey {
                    let binding: Binding<CGColor> = Binding(get: {
                        return try! Color(hex: dict[selectedKey]!).cgColor!
                    }, set: { cgColor in
                        var dict = dict
                        dict[selectedKey] = try! Color(UIColor(cgColor: cgColor)).hex()
                        lightTheme.wrappedValue = try! LightTheme(from: dict)
                    })
                    ColorPicker(selectedKey, selection: binding)
                        .frame(height: 44)
                        .padding(.horizontal, 16)
                }
                ForEach(dict.keys.sorted(), id: \.hashValue) { key in
                    let hex = dict[key]
                    ActionItem(title: key, color: dict[key], action: {
                        selectedKey = key
                        selectedColor = try! Color(hex: hex!).cgColor!
                    })
                }
            }
            .padding(.vertical, 8)
        }
    }
}
