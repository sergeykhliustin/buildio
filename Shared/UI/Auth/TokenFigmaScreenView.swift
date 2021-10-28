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
            }
//            .padding(.horizontal, 16)
            .background(Color.white)
            
            VStack(alignment: .center, spacing: 25) {
                HStack(spacing: 0) {
                    Text("Don't have one? ")
                        .foregroundColor(.black)
                        .font(.callout)
                    Button {
                        guard let url = URL(string: "https://app.bitrise.io/me/profile#/security") else {
                            return
                        }
                        
                        openURL(url)
                    } label: {
                        Text("Click here").foregroundColor(Color.b_ButtonPrimaryLight)
                    }
                    .font(.callout)
                }
                
                Button("Submit") {
                    checkToken(tokenState)
//                    token = tokenState
                }.buttonStyle(SubmitButtonStyle()).disabled(tokenState.isEmpty || isError)
                    .frame(alignment: .center)
            }
            .padding(.horizontal)
            .background(Color.white)
            
        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(16)
        .alert(isPresented: $isError) {
            Alert(title: Text("Error"),
                  message: Text(error?.localizedDescription ?? "Unknown error"), dismissButton: .cancel {
                error = nil
                isError = false
            })
        }
    }
    
    private func checkToken(_ token: String) {
        isLoading = true
        var checker: Any?
        checker = UserAPI(apiToken: token).userProfile()
            .sink { subscribersCompletion in
                if case .failure(let error) = subscribersCompletion {
                    self.error = error
                    self.isError = true
                }
                isLoading = false
                checker = nil
            } receiveValue: { model in
                if let email = model.data.email {
                    TokenManager.shared.token = Token(token: token, email: email)
                    onCompletion?()
                } else {
                    self.isError = true
                }
            }
    }
}

struct TokenFigmaScreenView_Previews: PreviewProvider {
    static var previews: some View {
        TokenFigmaScreenView()
            .previewDevice("iPhone 8")
    }
}
