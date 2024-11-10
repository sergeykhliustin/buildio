//
//  SettingsPage.swift
//  Modules
//
//  Created by Sergii Khliustin on 08.11.2024.
//

import Foundation
import SwiftUI
import UITypes
import Dependencies
import Components
import Assets

package struct SettingsPage: PageType {
    @Environment(\.theme) private var theme
    @ObservedObject package var viewModel: SettingsPageModel

    package init(viewModel: SettingsPageModel) {
        self.viewModel = viewModel
    }

    package var content: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                Text("Notifications")
                    .section()
                ToggleSettingsItem(title: "Mute all 'no matching pipeline found*' notifications", icon: nil, toggle: $viewModel.settings.muteAllNoPipeline)

                Text("Color settings")
                    .section()
                ListItem {
                    HStack(spacing: 0) {
                        Text("Preferred color scheme")
                        Spacer(minLength: 4)
                        Group {
                            Text("System")
                                .button {
                                    viewModel.settings.preferredColorScheme = nil
                                }
                                .padding(8)
                                .rounded(
                                    borderColor: viewModel.settings.preferredColorScheme == nil ? theme.accentColor.color : .clear
                                )
                            Text("Light")
                                .padding(8)
                                .button {
                                    viewModel.settings.preferredColorScheme = .light
                                }
                                .rounded(
                                    borderColor: viewModel.settings.preferredColorScheme == .light ? theme.accentColor.color : .clear
                                )
                            Text("Dark")
                                .button {
                                    viewModel.settings.preferredColorScheme = .dark
                                }
                                .padding(8)
                                .rounded(
                                    borderColor: viewModel.settings.preferredColorScheme == .dark ? theme.accentColor.color : .clear
                                )
                        }
                        .foregroundColor(theme.textColorLight.color)
                        .font(.footnote)
                    }
                    .padding(.horizontal, 16)
                    .frame(minHeight: 44)
                }
                #if targetEnvironment(macCatalyst)
                Text("Buildio requests updates in the background with this interval. Slide to zero to disable")
                    .section()
                SliderSettingsItem(title: "Polling interval", value: $viewModel.settings.pollingInterval)
                #endif
                Text("-")
                    .section()
                NavigateSettingsItem(
                    title: "About",
                    action: {
                        viewModel.dependencies.navigator.show(.about)
                    })
            }
            .padding(.horizontal, 16)
        }
        .navigationTitle("Settings")
    }
}

struct SectionTextViewModifier: ViewModifier {
    @Environment(\.theme) private var theme

    func body(content: Content) -> some View {
        content
            .padding(.top, 8)
            .foregroundColor(theme.textColorLight.color)
            .font(.callout)
    }
}

extension View {
    func section() -> some View {
        modifier(SectionTextViewModifier())
    }
}

#Preview {
    SettingsPage(viewModel: SettingsPageModel(dependencies: DependenciesMock()))
}
