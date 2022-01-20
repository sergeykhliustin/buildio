//
//  ThemeConfiguratorScreenView.swift
//  
//
//  Created by Sergey Khliustin on 19.01.2022.
//

import Foundation
import SwiftUI

struct ThemeConfiguratorScreenView: View {
    @Environment(\.themeUpdater) var theme
    @State private var selectedKey: String?
    @State private var selectedColor: CGColor = Color.clear.cgColor!
    
    var body: some View {
        let dict = theme.wrappedValue.dictionary as? [String: String] ?? [:]
        
        ScrollView {
            VStack(spacing: 8) {
                ForEach(dict.keys.sorted(), id: \.hashValue) { key in
                    let binding: Binding<CGColor> = Binding(get: {
                        return try! Color(hex: dict[key]!).cgColor!
                    }, set: { cgColor in
                        var dict = dict
                        dict[key] = try! Color(UIColor(cgColor: cgColor)).hex()
                        theme.wrappedValue = try! Theme(from: dict)
                    })
                    
                    ColorPicker(key, selection: binding)
                        .frame(height: 44)
                        .padding(.horizontal, 16)
                }
            }
            .padding(.vertical, 8)
        }
        .navigationTitle("Theme")
    }
}
