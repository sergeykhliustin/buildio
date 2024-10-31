//
//  ThemeConfiguratorScreenView.swift
//  
//
//  Created by Sergey Khliustin on 19.01.2022.
//

import Foundation
import SwiftUI
import BuildioLogic

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
                HStack {
                    EntryPoint(previewMode: true, theme: $themeToTune)
                        .frame(width: width, height: height, alignment: .center)
                        .cornerRadius(20)
                        .background(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1))
                        .scaleEffect(scale)
                        .padding(EdgeInsets(top: -height * scale / 2, leading: -width * scale / 2, bottom: -height * scale / 2, trailing: -width * scale / 2))
                    Group {
                        VStack {
                            AbortButton({})
                            
                            StartBuildButton("Rebuild", {})
                            
                            SubmitButton({})
                            
                            SubmitButton({})
                                .disabled(true)
                            
                            Button {
                                
                            } label: {
                                Text("Click here")
                            }
                            .buttonStyle(LinkButtonStyle())
                            
                            Button(action: {
                                
                            }, label: {
                                Image(.note_text)
                                Text("Logs")
                            })
                                .buttonStyle(ControlButtonStyle())
                        }
                        .scaleEffect(0.8)
                        
                        VStack {
                            ForEach(Platform.allCases, id: \.rawValue) { item in
                                PlatformIcon(platform: item)
                            }
                        }
                    }
                    .foregroundColor(themeToTune.textColor)
                    .background(themeToTune.background)
                    .environment(\.theme, themeToTune)
                    
                }
                
                ScrollView {
                    VStack(spacing: 8) {
                        let keys = dict.keys.sorted().filter({ $0 != "scheme" && $0 != "name" })
                        ForEach(keys, id: \.hashValue) { key in
                            // swiftlint:disable force_try
                            let binding: Binding<CGColor> = Binding(get: {
                                return try! Color(hex: dict[key]!).cgColor!
                            }, set: { cgColor in
                                var dict = dict
                                dict[key] = try! Color(UIColor(cgColor: cgColor)).hex()
                                themeToTune = try! Theme(from: dict)
                            })
                            // swiftlint:enable force_try
                            
                            HStack {
                                Text(key)
                                Spacer()
                                Text(dict[key]!)
                                
                                ColorPicker("", selection: binding)
                                    .frame(height: 44)
                                    
                            }
                            .padding(.horizontal, 16)
                            
                        }
                        
                        NavigateSettingsItem(title: "Export", icon: .square_and_arrow_up_fill) {
                            let encoder = JSONEncoder()
                            do {
                                let data = try encoder.encode(themeToTune)
                                let url = URL(fileURLWithPath: (NSTemporaryDirectory() as NSString).appendingPathComponent("theme.json"))
                                try data.write(to: url)
                                let controller = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                                controller.popoverPresentationController?.sourceView = UIView()
                                UIApplication.shared.rootViewController?.present(controller, animated: true)
                            } catch {
                                logger.error(error)
                            }
                        }
                        NavigateSettingsItem(title: "Apply theme", icon: .empty) {
                            themeUpdater.wrappedValue = themeToTune
                        }
                        NavigateSettingsItem(title: "Reset theme changes", icon: .empty) {
                            themeUpdater.wrappedValue = Theme.current
                        }
                    }
                }
                
            }
            .padding(.vertical, 8)
            
        }
        .background(theme.background)
    }
}

struct ThemeConfiguratorScreenView_Preview: PreviewProvider {
    static var previews: some View {
        ThemeConfiguratorScreenView(themeToTune: Theme.current)
    }
}
