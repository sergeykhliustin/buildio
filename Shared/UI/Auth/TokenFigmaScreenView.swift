//
//  TokenFigmaScreenView.swift
//  Buildio
//
//  Created by severehed on 21.10.2021.
//

import SwiftUI

struct TokenFigmaScreenView: View {
    @Environment(\.openURL) private var openURL
    @State var tokenState: String = ""
    
    @State private var isLoading: Bool = false
    @State private var isError: Bool = false
    @State private var error: Error?
    
    var onCompletion: (() -> Void)?
    
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
        .alert(isPresented: $isError) {
            Alert(title: Text("Error"),
                  message: Text(error?.localizedDescription ?? "Unknown error"), dismissButton: .cancel() {
                error = nil
                isError = false
            })
        }
    }
    
    private func checkToken(_ token: String) {
        isLoading = true
        SwaggerClientAPI.customHeaders["Authorization"] = token
        UserAPI.userProfile { data, error in
            isLoading = false
            SwaggerClientAPI.customHeaders["Authorization"] = token
            if let error = error {
                self.error = error
                self.isError = true
            } else {
                TokenManager.shared.setToken(token)
                onCompletion?()
            }
        }
    }
}

struct TokenFigmaScreenView_Previews: PreviewProvider {
    static var previews: some View {
        TokenFigmaScreenView()
    }
}
