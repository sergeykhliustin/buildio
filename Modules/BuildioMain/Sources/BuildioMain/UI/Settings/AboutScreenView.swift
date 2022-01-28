//
//  AboutScreenView.swift
//  
//
//  Created by Sergey Khliustin on 26.01.2022.
//

import SwiftUI

private extension Bundle {
    var icon: UIImage? {
        if let icons = infoDictionary?["CFBundleIcons"] as? [String: Any],
            let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
            let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
            let lastIcon = iconFiles.last {
            return UIImage(named: lastIcon)
        }
        return nil
    }
    
    var build: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    
    var version: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
}

struct AboutScreenView: View {
    @Environment(\.theme) private var theme: Theme
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let image = Bundle.main.icon {
                Image(uiImage: image)
                    .cornerRadius(10)
            }
            
            Text("Buildio \(Bundle.main.version ?? "") (\(Bundle.main.build ?? ""))")
                .font(.title)
            
            HStack(spacing: 0) {
                Text("Open source client for ")
                Link("Bitrise CI", destination: URL(string: "bitrise.io")!)
                    .foregroundColor(theme.linkColor)
            }
            
            HStack(spacing: 0) {
                Text("Source code available ")
                Link("on Github", destination: URL(string: "https://github.com/sergeykhliustin/buildio")!)
                    .foregroundColor(theme.linkColor)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Dependencies:")
                Group {
                    Link("SwiftyBeaver", destination: URL(string: "https://github.com/SwiftyBeaver/SwiftyBeaver")!)
                    Link("KeychainAccess", destination: URL(string: "https://github.com/kishikawakatsumi/KeychainAccess")!)
                    Link("Rainbow", destination: URL(string: "https://github.com/onevcat/Rainbow")!)
                }
                .foregroundColor(theme.linkColor)
            }
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.background)
        .navigationTitle("About")
    }
}

struct AboutScreenView_Preview: PreviewProvider {
    static var previews: some View {
        AboutScreenView()
    }
}
