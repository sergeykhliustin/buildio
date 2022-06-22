//
//  AuthScreenView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 21.10.2021.
//

import SwiftUI
import BuildioLogic

struct AuthScreenView: View {
    @EnvironmentObject private var navigator: Navigator
    @EnvironmentObject private var tokenManager: TokenManager
    @Environment(\.theme) private var theme
    @Environment(\.openURL) private var openURL
    
    @StateObject var model = AuthScreenViewModel()
    
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
                Image(.key)
                    .resizable()
                    .aspectRatio(contentMode: SwiftUI.ContentMode.fit)
                    .rotationEffect(Angle(degrees: 90))
                    .frame(width: 200, height: 130, alignment: .center)
                    .fixedSize()
                    .foregroundColor(theme.accentColor)
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
                    .modifier(ClearButton(text: $tokenState))
                    .modifier(PasteButton(text: $tokenState))
                    .modifier(RoundedBorderShadowModifier(focused: focused, horizontalPadding: 8))
                    .frame(height: 44)
                
                HStack(spacing: 0) {
                    Text("Don't have one? ")
                        .font(.callout)
                    Button {
                        #if targetEnvironment(macCatalyst)
                        guard let url = URL(string: "https://app.bitrise.io/me/profile#/security") else {
                            return
                        }
                        openURL(url)
                        #else
                        navigator.go(.getToken)
                        #endif
                    } label: {
                        Text("Click here")
                    }
                    .buttonStyle(LinkButtonStyle())
                }
                if !canClose {
                    HStack(spacing: 0) {
                        Text("Want to explore the app? ")
                            .font(.callout)
                        Button {
                            tokenManager.setupDemo()
                        } label: {
                            Text("Demo here")
                        }
                        .buttonStyle(LinkButtonStyle())
                    }
                }
                if model.state == .loading {
                    ProgressView()
                } else {
                    SubmitButton {
                        checkToken(tokenState)
                    }
                    .disabled(tokenState.isEmpty || isError)
                }
            }
            .disabled(model.state == .loading)
            .frame(maxWidth: 414, alignment: .center)
            .padding(16)
        }
        .onChange(of: model.state, perform: { newValue in
            switch newValue {
            case .value:
                if let token = model.token, let email = model.value?.data.email {
                    tokenManager.token = Token(token: token, email: email)
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
                    navigator.dismiss()
                } label: {
                    Image(.xmark)
                }
            }
        }
    }
    
    private func checkToken(_ token: String) {
        if !canClose && token.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == "demo" {
            tokenManager.setupDemo()
        } else {
            model.token = token
            model.refresh()
        }
    }
}

struct AuthScreenView_Previews: PreviewProvider {
    static var previews: some View {
        AuthScreenView()
            .previewDevice("iPhone 8")
    }
}
