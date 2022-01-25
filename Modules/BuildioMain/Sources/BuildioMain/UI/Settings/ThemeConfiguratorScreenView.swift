//
//  ThemeConfiguratorScreenView.swift
//  
//
//  Created by Sergey Khliustin on 19.01.2022.
//

import Foundation
import SwiftUI

struct ThemeConfiguratorScreenView: View {
    @Environment(\.themeUpdater) var themeUpdater
    @State var theme: Theme
    
    var body: some View {
        let dict = theme.dictionary as? [String: String] ?? [:]
        GeometryReader { geometry in
            VStack(spacing: 8) {
                let scale = 0.5
                let height = geometry.size.height
                let width = height / 19.5 * 9
                EntryPoint(previewMode: true, theme: $theme)
                    .frame(width: width, height: height, alignment: .center)
                    .cornerRadius(20)
                    .background(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1))
                    .scaleEffect(scale)
                    .padding(EdgeInsets(top: -height * scale / 2, leading: 0, bottom: -height * scale / 2, trailing: 0))
                
                    
                
                ScrollView {
                    VStack(spacing: 8) {
                        
                        ForEach(dict.keys.sorted(), id: \.hashValue) { key in
                            let binding: Binding<CGColor> = Binding(get: {
                                return try! Color(hex: dict[key]!).cgColor!
                            }, set: { cgColor in
                                var dict = dict
                                dict[key] = try! Color(UIColor(cgColor: cgColor)).hex()
                                theme = try! Theme(from: dict)
                            })
                            
                            ColorPicker(key, selection: binding)
                                .frame(height: 44)
                                .padding(.horizontal, 16)
                        }
                    }
                }
                IconActionItem(title: "Export", icon: "square.and.arrow.up.fill") {
                    let encoder = JSONEncoder()
                    do {
                        let data = try encoder.encode(theme)
                        let url = URL(fileURLWithPath: (NSTemporaryDirectory() as NSString).appendingPathComponent("theme.json"))
                        try data.write(to: url)
                        let controller = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                        
                        UIApplication.shared.windows.first?.rootViewController?.present(controller, animated: true)
                    } catch {
                        logger.error(error)
                    }
                }
                IconActionItem(title: "Apply theme", icon: "") {
                    themeUpdater.wrappedValue = theme
                }
            }
            .padding(.vertical, 8)
            
        }
        .navigationTitle("Theme")
    }
}

struct ThemeConfiguratorScreenView_Preview: PreviewProvider {
    static var previews: some View {
        ThemeConfiguratorScreenView(theme: Theme(colorScheme: .light))
    }
}
