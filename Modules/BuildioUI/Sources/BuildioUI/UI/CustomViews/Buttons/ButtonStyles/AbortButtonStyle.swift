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
        @Environment(\.theme) private var theme
        let configuration: ButtonStyle.Configuration
        let edgeInsets: EdgeInsets
        @Environment(\.isEnabled) private var isEnabled: Bool
        
        var body: some View {
            var colors: [Color] = [theme.abortButtonColor1, theme.abortButtonColor2]
            
            if configuration.isPressed {
                colors.removeFirst()
            }
            if !isEnabled {
                colors = [theme.disabledColor]
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
                    ).cornerRadius(20)
                )
        }
    }
}
