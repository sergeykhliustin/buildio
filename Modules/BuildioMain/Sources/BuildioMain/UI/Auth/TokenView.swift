//
//  TokenView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 21.10.2021.
//

import SwiftUI

struct TokenView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.openURL) private var openURL
    
    @StateObject var model = TokenViewModel()
    
    @State var tokenState: String = ""
    
    @State private var isError: Bool = false
    @State private var focused: Bool = false
    
    private let canClose: Bool
    private let onCompletion: (() -> Void)?
    
    init(canClose: Bool = false, onCompletion: (() -> Void)? = nil) {
        self.canClose = canClose
        self.onCompletion = onCompletion
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Spacer()
                Image(systemName: "key")
                    .resizable()
                    .aspectRatio(contentMode: SwiftUI.ContentMode.fit)
                    .rotationEffect(Angle(degrees: 90))
                    .frame(width: 200, height: 130, alignment: .center)
                    .fixedSize()
                    .foregroundColor(.b_PrimaryLight)
                Spacer()
                
                HStack {
                    Text("API Token")
                        .font(.callout)
                        .lineSpacing(24)
                    Spacer()
                }
                
                TextField("*******************",
                          text: $tokenState,
                          onEditingChanged: { editing in
                    self.focused = editing
                })
                    .font(.callout)
                    .foregroundColor(.b_TextBlack)
                    .modifier(ClearButton(text: $tokenState))
                    .modifier(PasteButton(text: $tokenState))
                    .modifier(RoundedBorderShadowModifier(borderColor: focused ? .b_Primary : .b_BorderLight, horizontalPadding: 8))
                    .frame(height: 44)
                
                HStack(spacing: 0) {
                    Text("Don't have one? ")
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
                    .buttonStyle(.plain)
                }
                if model.state == .loading {
                    ProgressView()
                } else {
                    Button("Submit") {
                        checkToken(tokenState)
                    }.buttonStyle(SubmitButtonStyle()).disabled(tokenState.isEmpty || isError)
                }
            }
            .frame(maxWidth: 414, alignment: .center)
            .padding(16)
        }
        .onChange(of: model.state, perform: { newValue in
            switch newValue {
            case .value:
                if let token = model.token, let email = model.value?.data.email {
                    TokenManager.shared.token = Token(token: token, email: email)
                    onCompletion?()
                }
            case .idle:
                break
            case .loading:
                break
            case .error:
                isError = true
            }
        })
        .alert(isPresented: $isError) {
            Alert(title: Text("Error"),
                  message: Text(model.error?.rawErrorString ?? "Unknown error"), dismissButton: .cancel(Text("OK")) {
                isError = false
            })
        }
        .navigationTitle("Log in to Bitrise")
        .toolbar {
            if canClose {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
            }
        }
    }
    
    private func checkToken(_ token: String) {
        model.token = token
        model.refresh()
    }
}

struct TokenView_Previews: PreviewProvider {
    static var previews: some View {
        TokenView()
            .previewDevice("iPhone 8")
    }
}
