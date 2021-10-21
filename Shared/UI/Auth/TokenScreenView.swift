//
//  TokenScreenView.swift
//  Buildio
//
//  Created by severehed on 01.10.2021.
//

import SwiftUI

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
