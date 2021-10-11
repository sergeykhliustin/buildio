//
//  TokenScreenView.swift
//  Buildio
//
//  Created by severehed on 01.10.2021.
//

import SwiftUI

private struct SubmitButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        SButton(configuration: configuration)
    }
    
    struct SButton: View {
        let configuration: ButtonStyle.Configuration
        @Environment(\.isEnabled) private var isEnabled: Bool
        
        var body: some View {
            var colors: [Color] = [Color(hex: 0x6c0eb2), Color(hex: 0x450674)]
            if !isEnabled {
                colors = [Color.gray]
            }
            
            return configuration.label
                .padding(EdgeInsets(top: 16, leading: 30, bottom: 16, trailing: 30))
                .foregroundColor(.white)
                .font(Font.body.bold())
                .background(
                    LinearGradient(
                        colors: configuration.isPressed ? colors.reversed() : colors,
                        startPoint: .top,
                        endPoint: .bottom
                    ).cornerRadius(4)
                )
        }
    }
}

struct TokenScreenView: View {
    @Binding var token: String?
    @State var tokenState: String = ""
    
    var body: some View {
        VStack {
            BTextField("API token", text: $tokenState)
            
            Button("Submit") {
                token = tokenState
            }.buttonStyle(SubmitButtonStyle()).disabled(tokenState.isEmpty)
        }.padding()
    }
}

struct TokenView_Previews: PreviewProvider {
    static var previews: some View {
        TokenScreenView(token: .constant("token here"))
    }
}
