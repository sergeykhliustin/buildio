//
//  AuthPage.swift
//  Buildio
//
//  Created by Sergey Khliustin on 21.10.2021.
//

import SwiftUI
import Components
import UITypes
import Dependencies

package struct AuthPage: PageType {
    @ObservedObject package var viewModel: AuthPageModel
    @Environment(\.theme) private var theme
    @Environment(\.openURL) private var openURL

    package init(viewModel: AuthPageModel) {
        self.viewModel = viewModel
    }

    package var content: some View {
        ScrollView {
            VStack(spacing: 16) {
                Spacer()
                Image(.key)
                    .resizable()
                    .aspectRatio(contentMode: SwiftUI.ContentMode.fit)
                    .rotationEffect(Angle(degrees: 90))
                    .frame(width: 200, height: 130, alignment: .center)
                    .fixedSize()
                    .foregroundColor(theme.accentColor.color)
                Spacer()

                HStack {
                    Text("API Token")
                        .font(.callout)
                        .lineSpacing(24)
                    Spacer()
                }

                BuildioTextField(
                    text: $viewModel.token,
                    placeholder: "*******************",
                    canClear: true,
                    canPaste: true
                )

                HStack(spacing: 0) {
                    Text("Don't have one? ")
                        .font(.callout)

                    Text("Click here")
                        .linkButton {
                            guard
                                let url = URL(string: "https://app.bitrise.io/me/profile#/security")
                            else {
                                return
                            }
                            openURL(url)
                        }
                }
                if viewModel.canDemo {
                    HStack(spacing: 0) {
                        Text("Want to explore the app? ")
                            .font(.callout)

                        Text("Demo here")
                            .linkButton(action: viewModel.onDemo)
                    }
                }
                if viewModel.isLoading {
                    BuildioProgressView()
                } else {
                    Text("Submit")
                        .submitButton {
                            viewModel.validate()
                        }
                        .disabled(viewModel.token.isEmpty)
                }
            }
            .disabled(viewModel.isLoading)
            .frame(maxWidth: 414, alignment: .center)
            .padding(16)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .navigationTitle("Log in to Bitrise")
    }
}

#Preview {
    AuthPage(
        viewModel: AuthPageModel(
            dependencies: DependenciesMock(),
            canDemo: true
        )
    )
}
