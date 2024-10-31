//
//  AboutScreenView.swift
//  
//
//  Created by Sergey Khliustin on 26.01.2022.
//

import SwiftUI
import BuildioLogic

private extension Bundle {
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
        VStack(alignment: .center, spacing: 16) {
            if let imagePath = Bundle.main.path(forResource: "app_icon", ofType: "png"),
                let image = UIImage(contentsOfFile: imagePath) {
                Image(uiImage: image)
                    .cornerRadius(30)
                    .background(
                        RoundedRectangle(cornerRadius: 30).shadow(color: theme.shadowColor, radius: 10, x: 0, y: 10)
                    )
            }
            VStack(alignment: .leading, spacing: 16) {
                
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
                        Link("MarkdownUI", destination: URL(string: "https://github.com/gonzalezreal/MarkdownUI")!)
                        Link("SwiftyBeaver", destination: URL(string: "https://github.com/SwiftyBeaver/SwiftyBeaver")!)
                        Link("KeychainAccess", destination: URL(string: "https://github.com/kishikawakatsumi/KeychainAccess")!)
                        Link("Rainbow", destination: URL(string: "https://github.com/onevcat/Rainbow")!)
                    }
                    .foregroundColor(theme.linkColor)
                }
            }
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.background)
    }
}

struct AboutScreenView_Preview: PreviewProvider {
    static var previews: some View {
        AboutScreenView()
    }
}
