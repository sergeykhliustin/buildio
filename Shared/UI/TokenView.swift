//
//  TokenView.swift
//  Buildio
//
//  Created by severehed on 01.10.2021.
//

import SwiftUI

struct TokenView: View {
    @Binding var token: String?
    @State var tokenState: String = ""
    
    var body: some View {
        VStack {
            TextField("API token", text: $tokenState).padding()
            Button("Submit") {
                token = tokenState
            }
        }.padding()
    }
}

struct TokenView_Previews: PreviewProvider {
    static var previews: some View {
        TokenView(token: .constant("token here"))
    }
}
