//
//  ThemeConfiguratorScreenView.swift
//  
//
//  Created by Sergey Khliustin on 19.01.2022.
//

import Foundation
import SwiftUI

struct ThemeConfiguratorScreenView: View {
    @Environment(\.theme) private var theme
    @Environment(\.themeUpdater) var themeUpdater
    @State var themeToTune: Theme
    
    var body: some View {
        let dict = themeToTune.dictionary as? [String: String] ?? [:]
        GeometryReader { geometry in
            VStack(spacing: 8) {
                let scale = 0.5
                let height = geometry.size.height
                let width = height / 16 * 9
                EntryPoint(previewMode: true, theme: $themeToTune)
                    .frame(width: width, height: height, alignment: .center)
                    .cornerRadius(20)
                    .background(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1))
                    .scaleEffect(scale)
                    .padding(EdgeInsets(top: -height * scale / 2, leading: 0, bottom: -height * scale / 2, trailing: 0))
                
                ScrollView {
                    VStack(spacing: 8) {
                        let keys = dict.keys.sorted().filter({ $0 != "scheme" })
                        ForEach(keys, id: \.hashValue) { key in
                            let binding: Binding<CGColor> = Binding(get: {
                                return try! Color(hex: dict[key]!).cgColor!
                            }, set: { cgColor in
                                var dict = dict
                                dict[key] = try! Color(UIColor(cgColor: cgColor)).hex()
                                themeToTune = try! Theme(from: dict)
                            })
                            
                            ColorPicker(key, selection: binding)
                                .frame(height: 44)
                                .padding(.horizontal, 16)
                        }
                        
                        IconActionItem(title: "Export", icon: "square.and.arrow.up.fill") {
                            let encoder = JSONEncoder()
                            do {
                                let data = try encoder.encode(themeToTune)
                                let url = URL(fileURLWithPath: (NSTemporaryDirectory() as NSString).appendingPathComponent("theme.json"))
                                try data.write(to: url)
                                let controller = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                                
                                UIApplication.shared.windows.first?.rootViewController?.present(controller, animated: true)
                            } catch {
                                logger.error(error)
                            }
                        }
                        IconActionItem(title: "Apply theme", icon: "") {
                            themeUpdater.wrappedValue = themeToTune
                        }
                        IconActionItem(title: "Save theme", icon: "") {
                            themeToTune.save()
                        }
                        IconActionItem(title: "Reset theme changes", icon: "") {
                            UserDefaults.standard.resetTheme()
                        }
                    }
                }
                
            }
            .padding(.vertical, 8)
            
        }
        .background(theme.background)
        .navigationTitle("Theme")
    }
}

struct ThemeConfiguratorScreenView_Preview: PreviewProvider {
    static var previews: some View {
        ThemeConfiguratorScreenView(themeToTune: Theme.theme(for: .light))
    }
}
