//
//  TokenFigmaScreenView.swift
//  Buildio
//
//  Created by severehed on 21.10.2021.
//

import SwiftUI

struct TokenFigmaScreenView: View {
    @Environment(\.openURL) private var openURL
    @Binding var token: String?
    @State var tokenState: String = ""
    
    var body: some View {
        VStack {
//            Rectangle()
//                .fill(Color.b_Primary)
////                .padding(.bottom, 20)
//                .frame(maxWidth: .infinity, idealHeight: 64, maxHeight: 64, alignment: .top)
////                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 25.53) {
                
                Text("Log in to Bitrise")
                    .font(.largeTitle)
                    .frame(alignment: .topLeading)
                    .lineSpacing(48)
                Text("API Token")
                    .font(.callout)
                    .frame(width: 137, alignment: .topLeading)
                    .lineSpacing(24)
                
                
                BTextField("*******************", text: $tokenState)
                    .modifier(ClearButton(text: $tokenState))
                    .modifier(PasteButton(text: $tokenState))
                
                
                Button {
                    guard let url = URL(string: "https://app.bitrise.io/me/profile#/security") else {
                        return
                    }
                    
                    openURL(url)
                } label: {
                    HStack(spacing: 0) {
                        Text("Get your token ").foregroundColor(.black)
                            
                        Text("here").foregroundColor(Color(hex: 0x760FC3))
                    }
                    .font(.callout)
                }
            }
            .padding(.horizontal)
            .background(Color.white)
            
            Button("Submit") {
                token = tokenState
            }.buttonStyle(SubmitButtonStyle()).disabled(tokenState.isEmpty)
                .frame(alignment: .center)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
}

struct TokenFigmaScreenView_Previews: PreviewProvider {
    static var previews: some View {
        TokenFigmaScreenView(token: .constant(nil))
            
    }
}
