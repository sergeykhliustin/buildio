//
//  AbortButtonStyle.swift
//  
//
//  Created by Sergey Khliustin on 07.12.2021.
//

import SwiftUI

struct AbortButtonStyle: ButtonStyle {
    var edgeInsets = EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 15)
    
    func makeBody(configuration: Configuration) -> some View {
        SButton(configuration: configuration, edgeInsets: edgeInsets)
    }
    
    struct SButton: View {
        let configuration: ButtonStyle.Configuration
        let edgeInsets: EdgeInsets
        @Environment(\.isEnabled) private var isEnabled: Bool
        
        var body: some View {
            var colors: [Color] = [.red, .red.opacity(0.8)]
            
            if configuration.isPressed {
                colors.removeLast()
            }
            if !isEnabled {
                colors = [Color.b_BorderLight]
            }
            
            return configuration.label
                .padding(edgeInsets)
                .foregroundColor(.white)
                .font(Font.body.bold())
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: colors),
                        startPoint: .top,
                        endPoint: .bottom
                    ).cornerRadius(4)
                )
        }
    }
}
