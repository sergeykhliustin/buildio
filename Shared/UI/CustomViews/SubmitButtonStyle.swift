//
//  SubmitButtonStyle.swift
//  Buildio
//
//  Created by Sergey Khliustin on 21.10.2021.
//

import SwiftUI

struct SubmitButtonStyle: ButtonStyle {
    var edgeInsets = EdgeInsets(top: 16, leading: 30, bottom: 16, trailing: 30)
    
    func makeBody(configuration: Configuration) -> some View {
        SButton(configuration: configuration, edgeInsets: edgeInsets)
    }
    
    struct SButton: View {
        let configuration: ButtonStyle.Configuration
        let edgeInsets: EdgeInsets
        @Environment(\.isEnabled) private var isEnabled: Bool
        
        var body: some View {
            var colors: [Color] = [.b_ButtonPrimaryLight, .b_ButtonPrimary]
            
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
